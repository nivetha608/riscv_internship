package VectorRegisterFile;

import Vector::*;
import VectorTypes::*;

interface VectorRegFileIFC;
    method Action write(VRegIndex idx , VectorReg val); // takes the index and val to be writen
    method VectorReg read(VRegIndex idx);  // reads the value from the index
endinterface

module mkVectorRegisterFile(VectorRegFileIFC);

    Vector#(NumVectorRegs, Reg#(VectorReg)) regs <- replicateM(mkRegU); //replicate all 32 vectors v0-v31

    method Action write(VRegIndex idx, VectorReg val);
        regs[idx] <= val; // writes the val
    endmethod

    method VectorReg read(VRegIndex idx);
        return regs[idx]; // reads the val
    endmethod


endmodule

endpackage
