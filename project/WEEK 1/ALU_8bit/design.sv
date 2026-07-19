module ALU (
    input logic clk,
    input logic rst_n,
    input logic [7:0] A,         
    input logic [7:0] B,        
    input logic [1:0] ALU_Sel,   
    output logic [8:0] ALU_Out
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n)
            ALU_Out <= 0;
        else begin
            case (ALU_Sel)
                2'b00: ALU_Out <= A + B;        // ADD
                2'b01: ALU_Out <= A - B;        // SUB
                2'b10: ALU_Out <= A & B;        // AND
                2'b11: ALU_Out <= A | B;        // OR
                default: ALU_Out <= 9'b0;
            endcase
        end
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, ALU);
    end

endmodule
