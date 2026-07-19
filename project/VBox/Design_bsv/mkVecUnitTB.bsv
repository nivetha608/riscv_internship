package mkVecUnitTB;

import mkVecUnit::*;
import Vector::*;
import List::*;           
import VectorTypes::*;
import StmtFSM::*;
import RegFile::*;       

(* synthesize *)
module mkTestbench();

    VecUnitIFC dut <- mkVecUnit;
    Reg#(Bit#(32)) timeout_reg <- mkReg(0);

    Stmt test = seq
        $display("[TB] Starting Vector Unit Test...");

        action
            Vector#(8, Bit#(32)) v1_data_vec;
            v1_data_vec[0] = 32'd10;
            v1_data_vec[1] = 32'd20;
            v1_data_vec[2] = 32'd30;
            v1_data_vec[3] = 32'd40;
            v1_data_vec[4] = 32'd0;
            v1_data_vec[5] = -32'd10;
            v1_data_vec[6] = 32'd0;
            v1_data_vec[7] = 32'd0;
            dut.writeReg(1, v1_data_vec);
        endaction

        action
            Vector#(8, Bit#(32)) v2_data_vec;
            v2_data_vec[0] = 32'd1;
            v2_data_vec[1] = 32'd2;
            v2_data_vec[2] = 32'd3;
            v2_data_vec[3] = 32'd4;
            v2_data_vec[4] = 32'd0;
            v2_data_vec[5] = -32'd30;
            v2_data_vec[6] = 32'd0;
            v2_data_vec[7] = -32'd20;
            dut.writeReg(2, v2_data_vec);
        endaction

        $display("[TB] Preloaded vector registers v1 and v2");

        // VADD_VV Test
        dut.execute(VecInstr { op: VADD_VV, vs1: 1, vs2: 2, vd: 3, baseAddr: 64'd0 });
        $display("[TB] Issued VADD_VV instruction");

        timeout_reg <= 32'd1000;
        while (!dut.done && timeout_reg > 0) action
            noAction; timeout_reg <= timeout_reg - 1;
        endaction
        action
            if (timeout_reg == 0) begin
               $display("[TB] Timeout during VADD_VV execution"); $finish;
            end
        endaction

        action
            let reg3 <- dut.readReg(3);
            $display("[TB] VADD_VV result in v3:");
            for (Integer i = 0; i < 8; i = i + 1) begin
                $display("  v3[%0d] = %0d", i, unpack(reg3[i]));
            end
        endaction

        // VSUB_VV Test
        dut.execute(VecInstr { op: VSUB_VV, vs1: 1, vs2: 2, vd: 4, baseAddr: 64'd0 });
        $display("[TB] Issued VSUB_VV instruction");

        timeout_reg <= 32'd1000;
        while (!dut.done && timeout_reg > 0) action
            noAction; timeout_reg <= timeout_reg - 1;
        endaction
        action
            if (timeout_reg == 0) begin
               $display("[TB] Timeout during VSUB_VV execution"); $finish;
            end
        endaction

        action
            let reg4 <- dut.readReg(4);
            $display("[TB] VSUB_VV result in v4:");
            for (Integer i = 0; i < 8; i = i + 1) begin
                $display("  v4[%0d] = %0d", i, unpack(reg4[i]));
            end
        endaction

        // VSTORE Test 
        dut.execute(VecInstr { op: VSTORE, vs1: 4, vs2: 0, vd: 0, baseAddr: 64'd100 });
        $display("[TB] Issued VSTORE of v4 to addr 100");

        timeout_reg <= 32'd1000;
        while (!dut.done && timeout_reg > 0) action
            noAction; timeout_reg <= timeout_reg - 1;
        endaction
        action
            if (timeout_reg == 0) begin
               $display("[TB] Timeout during VSTORE execution"); $finish;
            end
        endaction

        // VLOAD Test
        dut.execute(VecInstr { op: VLOAD, vs1: 0, vs2: 0, vd: 10, baseAddr: 64'd100 });
        $display("[TB] Issued VLOAD to v10 from addr 100");

        timeout_reg <= 32'd1000;
        while (!dut.done && timeout_reg > 0) action
            noAction; timeout_reg <= timeout_reg - 1;
        endaction
        action
            if (timeout_reg == 0) begin
               $display("[TB] Timeout during VLOAD execution"); $finish;
            end
        endaction

        action
            let reg10 <- dut.readReg(10);
            $display("[TB] VLOAD result in v10:");
            for (Integer i = 0; i < 8; i = i + 1) begin
                $display("  v10[%0d] = %0d", i, unpack(reg10[i]));
            end
        endaction
        

        $display("[TB] All vector tests completed successfully.");
        $finish;

    endseq;

    mkAutoFSM(test);

endmodule

endpackage
