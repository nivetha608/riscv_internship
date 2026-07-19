module logic_256bit (
    input wire [255:0] a_i, b_i,
    input wire [2:0] sew_i,
    input wire [5:0] opcode_i, 
    input wire clk_i,
    input wire rst_i,
    output reg [255:0] out_o
);

localparam ALU_VAND    = 6'd0;
localparam ALU_VNAND   = 6'd1;
localparam ALU_VANDNOT = 6'd2;
localparam ALU_VOR     = 6'd3;
localparam ALU_VNOR    = 6'd4;
localparam ALU_VXOR    = 6'd5;
localparam ALU_VXNOR   = 6'd6;
localparam ALU_VNOT    = 6'd7;
localparam ALU_VSLL    = 6'd8;
localparam ALU_VSRL    = 6'd9;
localparam ALU_VSRA    = 6'd10;

reg [255:0] result_logic;
reg [255:0] result_shift;

integer i;

always @* begin
    case (opcode_i)
        ALU_VAND    : result_logic = a_i & b_i;
        ALU_VNAND   : result_logic = ~(a_i & b_i);
        ALU_VANDNOT : result_logic = a_i & ~b_i;
        ALU_VOR     : result_logic = a_i | b_i;
        ALU_VNOR    : result_logic = ~(a_i | b_i);
        ALU_VXOR    : result_logic = a_i ^ b_i;
        ALU_VXNOR   : result_logic = ~(a_i ^ b_i);
        ALU_VNOT    : result_logic = ~a_i;
        default     : result_logic = 256'b0;
    endcase
end

always @* begin
    result_shift = 256'b0;
    case (sew_i)
        3'b000: begin
            for (i = 0; i < 32; i = i + 1) begin
                case (opcode_i)
                    ALU_VSLL: result_shift[i*8 +: 8] = a_i[i*8 +: 8] << b_i[i*8 +: 8];
                    ALU_VSRL: result_shift[i*8 +: 8] = a_i[i*8 +: 8] >> b_i[i*8 +: 8];
                    ALU_VSRA: result_shift[i*8 +: 8] = $signed(a_i[i*8 +: 8]) >>> b_i[i*8 +: 8];
                    default:  result_shift[i*8 +: 8] = 8'b0;
                endcase
            end
        end
        3'b001: begin
            for (i = 0; i < 16; i = i + 1) begin
                case (opcode_i)
                    ALU_VSLL: result_shift[i*16 +: 16] = a_i[i*16 +: 16] << b_i[i*16 +: 16];
                    ALU_VSRL: result_shift[i*16 +: 16] = a_i[i*16 +: 16] >> b_i[i*16 +: 16];
                    ALU_VSRA: result_shift[i*16 +: 16] = $signed(a_i[i*16 +: 16]) >>> b_i[i*16 +: 16];
                    default:  result_shift[i*16 +: 16] = 16'b0;
                endcase
            end
        end
        3'b010: begin 
            for (i = 0; i < 8; i = i + 1) begin
                case (opcode_i)
                    ALU_VSLL: result_shift[i*32 +: 32] = a_i[i*32 +: 32] << b_i[i*32 +: 32];
                    ALU_VSRL: result_shift[i*32 +: 32] = a_i[i*32 +: 32] >> b_i[i*32 +: 32];
                    ALU_VSRA: result_shift[i*32 +: 32] = $signed(a_i[i*32 +: 32]) >>> b_i[i*32 +: 32];
                    default:  result_shift[i*32 +: 32] = 32'b0;
                endcase
            end
        end
        3'b011: begin
            for (i = 0; i < 4; i = i + 1) begin
                case (opcode_i)
                    ALU_VSLL: result_shift[i*64 +: 64] = a_i[i*64 +: 64] << b_i[i*64 +: 64];
                    ALU_VSRL: result_shift[i*64 +: 64] = a_i[i*64 +: 64] >> b_i[i*64 +: 64];
                    ALU_VSRA: result_shift[i*64 +: 64] = $signed(a_i[i*64 +: 64]) >>> b_i[i*64 +: 64];
                    default:  result_shift[i*64 +: 64] = 64'b0;
                endcase
            end
        end
        default: result_shift = 256'b0;
    endcase
end

always @* begin
    case (opcode_i)
        ALU_VAND, ALU_VNAND, ALU_VANDNOT, ALU_VOR,
        ALU_VNOR, ALU_VXOR, ALU_VXNOR, ALU_VNOT :
            out_o = result_logic;
        ALU_VSLL, ALU_VSRL, ALU_VSRA :
            out_o = result_shift;
        default:
            out_o = 256'b0;
    endcase
end

function [255:0] shift;
    input [255:0] a;
    input [255:0] b;
    input [5:0] op;
    begin
        case (op)
            ALU_VSLL : shift = a << b;
            ALU_VSRL : shift = a >> b;
            ALU_VSRA : shift = $signed(a) >>> b;
            default  : shift = 256'b0;
        endcase
    end
endfunction

endmodule
