package VectorTypes;

import Vector::*;
import Prelude::*;

typedef 32 NumVectorRegs;  // v0 to v31
typedef 8 VLEN;  // number of elements in reg
typedef 32 SEW;  // standard element width

typedef Vector#(VLEN, Bit#(SEW)) VectorReg;
typedef Bit#(5) VRegIndex; // 5 bits to select 32 registers

typedef enum {
    VADD_VV,
    VSUB_VV,
    VLOAD,
    VSTORE
} VecOp deriving (Bits, Eq);

// Instruction format (add this in VectorTypes)
typedef struct {
    VecOp op;
    VRegIndex vd;   // Destination vector register
    VRegIndex vs1;  // Source vector register 1
    VRegIndex vs2;  // Source vector register 2 (only for vv ops)
    Bit#(64) baseAddr; // Used for load/store
} VecInstr deriving (Bits, Eq);

endpackage
