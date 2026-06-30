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
    //Operações Brutas executadas pela ALU 
    always_comb begin
        case (Operation)
            5'd01:   ALUResult = $signed(SrcA) + $signed(SrcB); //ADD
            5'd02:   ALUResult = $signed(SrcA) - $signed(SrcB); //SUB
            5'd04:   ALUResult = SrcA | SrcB; //OR
            5'd05:   ALUResult = SrcA & SrcB; //AND
            5'd06:   ALUResult = SrcA ^ SrcB; //XOR
            5'd07:   ALUResult = SrcA << SrcB[4:0]; //SLL
            5'd08:   ALUResult = $signed(SrcA) >>> SrcB[4:0]; //SRA
            5'd09:   ALUResult = SrcA >> SrcB[4:0]; //SRL

            //A partir daqui, retirando a de número 12 (para LUI), todas geram saída de 0/1, pois são puramente lógicas
            
            5'd10:   ALUResult = $unsigned(SrcA) < $unsigned(SrcB) ? 32'b1: 32'b0; //SLTU
            5'd11:   ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'b1 : 32'b0;  //SLT
            5'd12:   ALUResult = SrcB; // Pass normal para LUI
            5'd13:   ALUResult = (SrcA != SrcB) ? 32'b0 : 32'b1;   //SEQ -> verifica igualdade                     
            5'd14:   ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'b0 : 32'b1;    //SLT -> verifica se menor  
            5'd15:   ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 32'b0 : 32'b1;   //SGE -> verifica se maior ou igual       
            5'd16:   ALUResult = ($unsigned(SrcA) < $unsigned(SrcB)) ? 32'b0 : 32'b1;    //SLTU -> verifica se menor unsigned
            5'd17:   ALUResult = ($unsigned(SrcA) >= $unsigned(SrcB)) ? 32'b0 : 32'b1;   //SGEU -> verifica se maior ou igual unsigned  

            default: ALUResult = 32'b0;
        endcase
    end

    assign Zero = (ALUResult == 32'b0);

endmodule
