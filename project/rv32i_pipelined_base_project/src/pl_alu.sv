// =============================================================================
// pl_alu.sv
// Unidade Logica e Aritmetica de 32 bits -- RV32I pipelined
//
// Codificacao de operacao (Operation[3:0]):
//   4'd01 : ADD  -- adicao com sinal
//   4'd02 : SUB  -- subtracao com sinal  (BEQ usa Zero)
//   4'd04 : OR   -- OU bit a bit
//   4'd05 : AND  -- E bit a bit
//   4'd06 : XOR  -- XOR bit a bit
//   4'd11 : SLT  -- set-less-than com sinal
// =============================================================================

`timescale 1ns / 1ps

module pl_alu (
    input  logic [31:0] SrcA,
    input  logic [31:0] SrcB,
    input  logic [4:0]  Operation,
    output logic [31:0] ALUResult,
    output logic        Zero
);

    always_comb begin
        case (Operation)
            5'd01:   ALUResult = $signed(SrcA) + $signed(SrcB); //ADD
            5'd02:   ALUResult = $signed(SrcA) - $signed(SrcB);
            5'd04:   ALUResult = SrcA | SrcB;
            5'd05:   ALUResult = SrcA & SrcB;
            5'd06:   ALUResult = SrcA ^ SrcB;
            5'd07:   ALUResult = SrcA << SrcB[4:0];
            5'd08:   ALUResult = $signed(SrcA) >>> SrcB[4:0];
            5'd09:   ALUResult = SrcA >> SrcB[4:0];
            5'd10:   ALUResult = $unsigned(SrcA) < $unsigned(SrcB) ? 32'b1: 32'b0;
            5'd11:   ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'b1 : 32'b0;

            default: ALUResult = 32'b0;
        endcase
    end

    assign Zero = (ALUResult == 32'b0);

endmodule
