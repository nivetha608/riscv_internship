module vector_alu (
    input wire clk_i,
    input wire rst_i,
    
    input wire [255:0] vs1_i,
    input wire [255:0] vs2_i,
    input wire [31:0] rs1_i,
    input wire [255:0] v0_i, 
    output wire [255:0] vd_o,
    input wire [2:0] sew_i,
    
    input wire signed_i,
    input wire use_mask_i,
    input wire use_carry_i,
    input wire produce_carry_i,
    input wire saturate_i,
    
    input wire [5:0] valu_op_i
);

localparam SEW8  = 3'b000;
localparam SEW16 = 3'b001;
localparam SEW32 = 3'b010;
localparam SEW64 = 3'b011;

localparam VALU_NOP  = 6'd0;
localparam VALU_ADDU = 6'd1;
localparam VALU_SUBU = 6'd2;

reg [255:0] vs1;
reg [255:0] vs2;
reg [255:0] temp_vd;

integer i;
always @* begin
    if (use_mask_i) begin
        case (sew_i)
            SEW8: begin
                for (i = 0; i < 32; i = i + 1) begin
                    vs1[i*8 +: 8] = vs1_i[i*8 +: 8] & ~v0_i[i*8 +: 8];
                    vs2[i*8 +: 8] = vs2_i[i*8 +: 8] & ~v0_i[i*8 +: 8];
                end
            end
            SEW16: begin
                for (i = 0; i < 16; i = i + 1) begin
                    vs1[i*16 +: 16] = vs1_i[i*16 +: 16] & ~v0_i[i*16 +: 16];
                    vs2[i*16 +: 16] = vs2_i[i*16 +: 16] & ~v0_i[i*16 +: 16];
                end
            end
            SEW32: begin
                for (i = 0; i < 8; i = i + 1) begin
                    vs1[i*32 +: 32] = vs1_i[i*32 +: 32] & ~v0_i[i*32 +: 32];
                    vs2[i*32 +: 32] = vs2_i[i*32 +: 32] & ~v0_i[i*32 +: 32];
                end
            end
            SEW64: begin
                for (i = 0; i < 4; i = i + 1) begin
                    vs1[i*64 +: 64] = vs1_i[i*64 +: 64] & ~v0_i[i*64 +: 64];
                    vs2[i*64 +: 64] = vs2_i[i*64 +: 64] & ~v0_i[i*64 +: 64];
                end
            end
            default: begin
                vs1 = vs1_i;
                vs2 = vs2_i;
            end
        endcase
    end else begin
        vs1 = vs1_i;
        vs2 = vs2_i;
    end
end

always @* begin
    temp_vd = 0;
    case (valu_op_i)
        VALU_ADDU: begin
            case (sew_i)
                SEW8: for (int i = 0; i < 32; i++) begin
                    temp_vd[i*8 +: 8] = vs1[i*8 +: 8] + vs2[i*8 +: 8];
                end
                SEW16: for (int i = 0; i < 16; i++) begin
                    temp_vd[i*16 +: 16] = vs1[i*16 +: 16] + vs2[i*16 +: 16];
                end
                SEW32: for (int i = 0; i < 8; i++) begin
                    temp_vd[i*32 +: 32] = vs1[i*32 +: 32] + vs2[i*32 +: 32];
                end
                SEW64: for (int i = 0; i < 4; i++) begin
                    temp_vd[i*64 +: 64] = vs1[i*64 +: 64] + vs2[i*64 +: 64];
                end
                default: temp_vd = 0;
            endcase
        end

        VALU_SUBU: begin
            case (sew_i)
                SEW8: for (int i = 0; i < 32; i++) begin
                    temp_vd[i*8 +: 8] = vs1[i*8 +: 8] - vs2[i*8 +: 8];
                end
                SEW16: for (int i = 0; i < 16; i++) begin
                    temp_vd[i*16 +: 16] = vs1[i*16 +: 16] - vs2[i*16 +: 16];
                end
                SEW32: for (int i = 0; i < 8; i++) begin
                    temp_vd[i*32 +: 32] = vs1[i*32 +: 32] - vs2[i*32 +: 32];
                end
                SEW64: for (int i = 0; i < 4; i++) begin
                    temp_vd[i*64 +: 64] = vs1[i*64 +: 64] - vs2[i*64 +: 64];
                end
                default: temp_vd = 0;
            endcase
        end

        default: temp_vd = 0;
    endcase
end


assign vd_o = temp_vd;

endmodule
