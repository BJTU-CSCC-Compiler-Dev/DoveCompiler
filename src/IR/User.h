#include "Use.h"
#include "Value.h"

namespace IR
{
  class User : public Value
  {
    Use *OperandList;
    unsigned NumOperands;

  public:
    User(Type type, unsigned numOperands);
    virtual ~User();

    unsigned getNumOperands() const { return NumOperands; }
    Use *getOperandList() const { return OperandList; }
  };
}
