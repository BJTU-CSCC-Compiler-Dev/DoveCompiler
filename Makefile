env/conan:
	pip3 install conan

env/antlr:
	mkdir -p res/antlr
	cd res/antlr && curl -O https://www.antlr.org/download/antlr-4.12.0-complete.jar

includes/runtime: res/conan/conanfile.txt
	mkdir -p $@
	cd $@ && conan install ../../res/conan/conanfile.txt
	touch $@

includes/generated: res/antlr/SysY.g4 res/antlr/CommonLex.g4 res/antlr/antlr-4.12.0-complete.jar
	mkdir -p $@
	cd res/antlr && java -Xmx500M -cp "antlr-4.12.0-complete.jar:$CLASSPATH" org.antlr.v4.Tool -Dlanguage=Cpp -visitor -no-listener -package front SysY.g4 -o ../../includes/generated
	touch $@

allres = includes/runtime includes/generated

build/bin/DoveCompiler:
	mkdir -p build
	cd build && cmake .. -G "Unix Makefiles" && make DoveCompiler

.PHONY: env/conan env/antlr includes/runtime include/generated all clean build test
.DEFAULT_GOAL := all

all: ${allres}

clean:
	rm -rf build

build: build/bin/DoveCompiler
		@build/bin/DoveCompiler --help

include tests/config.mk
testFileBase ?= main

test:	mkdir -p build && cd build && cmake .. -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Build && make
	build/ tests/${testFileBase}.sysy -o test/${testFileBase}.S ${options}