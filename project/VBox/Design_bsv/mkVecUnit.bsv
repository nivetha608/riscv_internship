package mkVecUnit;

import Prelude::*;
import Vector::*;
import VectorTypes::*;
import VectorRegisterFile::*;

// Memory size for vector memory
typedef 16 MEM_SIZE;  // Adjust as needed

interface VecUnitIFC;
    method Action execute(VecInstr instr);
    method Bool done;
    method VectorReg result;
    method Action writeReg(VRegIndex vi, VectorReg data);

    
    method ActionValue#(VectorReg) readReg(VRegIndex vi);
endinterface

module mkVecUnit(VecUnitIFC);

    VectorRegFileIFC vregs <- mkVectorRegisterFile;

    Reg#(Bool) busy <- mkReg(False);
    Reg#(Bool) pending <- mkReg(False);
    Reg#(VectorReg) resultReg <- mkReg(replicate(0));
    Reg#(VecInstr) instrReg <- mkRegU;

    // Vector memory: 16 registers of VectorReg
    Vector#(MEM_SIZE, Reg#(VectorReg)) vecMem <- replicateM(mkReg(replicate(0)));

    rule process_instruction(pending);
        VectorReg rs1 = vregs.read(instrReg.vs1);
        VectorReg rs2 = vregs.read(instrReg.vs2);
        VectorReg temp = replicate(0);

        case (instrReg.op)
            VADD_VV: begin
                for (Integer i = 0; i < valueOf(VLEN); i = i + 1)
                    temp[i] = rs1[i] + rs2[i];
            end

            VSUB_VV: begin
                for (Integer i = 0; i < valueOf(VLEN); i = i + 1)
                    temp[i] = rs1[i] - rs2[i];
            end

            VLOAD: begin
                if (instrReg.vs1 < fromInteger(valueOf(MEM_SIZE)))
                    temp = vecMem[pack(instrReg.vs1)];
            end

            VSTORE: begin
                if (instrReg.vd < fromInteger(valueOf(MEM_SIZE)))
                    vecMem[pack(instrReg.vd)] <= rs1;
            end

            default: begin end
        endcase

        // Write to register file only for compute/load
        if (instrReg.op != VSTORE) begin
            vregs.write(instrReg.vd, temp);
            resultReg <= temp;
        end

        pending <= False;
        busy <= False;
    endrule

    method Action execute(VecInstr instr);
        if (!busy) begin
            busy <= True;
            pending <= True;
            instrReg <= instr;
        end
    endmethod

    method Bool done = !busy;
    method VectorReg result = resultReg;

    method Action writeReg(VRegIndex vi, VectorReg data);
        vregs.write(vi, data);
    endmethod

    // 🔹 IMPLEMENTATION of readReg
    method ActionValue#(VectorReg) readReg(VRegIndex vi);
        return vregs.read(vi);
    endmethod

endmodule

endpackage
