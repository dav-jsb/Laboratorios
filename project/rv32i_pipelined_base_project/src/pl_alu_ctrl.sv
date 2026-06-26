// =============================================================================
// pl_alu_ctrl.sv
// Unidade de Controle da ALU -- RV32I pipelined (P&H secao 4.4)
//
// Entradas (do estagio EX -- registrador ID/EX):
//   ALUOp[1:0] : codigo do controlador principal
//     2'b00 : Load/Store  -> forcar ADD
//     2'b01 : Branch BEQ  -> forcar SUB
//     2'b10 : R-type      -> decodificar via Funct3/Funct7
//   Funct7[6:0], Funct3[2:0] : campos da instrucao
//
// Saida Operation[3:0] -> pl_alu.sv:
//   4'd01 ADD  4'd02 SUB  4'd04 OR  4'd05 AND  4'd11 SLT 4'd06 XOR
// =============================================================================

`timescale 1ns / 1ps

module pl_alu_ctrl (
    input  logic [2:0] ALUOp,
    input  logic [6:0] Funct7,
    input  logic [2:0] Funct3,
    output logic [4:0] Operation
);

// XOR, SLL, SRL, SRA, SLTU, ADDI, ANDI, ORI, SLTI, SLLI, SRLI, SRAI

    always_comb begin
        case (ALUOp)
            3'b000: Operation = 5'd01;  // Load / Store -> ADD

            3'b001: begin   // BRANCHES
                case (Funct3)
                    3'h0: Operation = 5'd02;  // BEQ  
                    3'h1: Operation = 5'd13;  // BNE  
                    3'h4: Operation = 5'd14;  // BLT  
                    3'h5: Operation = 5'd15;  // BGE  
                    3'h6: Operation = 5'd16;  // BLTU 
                    3'h7: Operation = 5'd17;  // BGEU 
                    default: Operation = 5'd02;
                endcase
            end

            3'b010: begin                // R-type: decodificar Funct
                case (Funct3)
                    3'h0: Operation = Funct7[5] ? 5'd02 : 5'd01; // SUB ou ADD

                    3'h1: Operation = 5'd07;  // SLL

                    3'h2: Operation = 5'd11;  // SLT

                    3'h3: Operation = 5'd10;  // SLTU
                    
                    3'h4: Operation = 5'd06;  // XOR

                    3'h5: Operation = Funct7[5] ? 5'd08 : 5'd09; // SRA ou SRL
                    
                    3'h6: Operation = 5'd04;  // OR

                    3'h7: Operation = 5'd05;  // AND

                    default: Operation = 5'd01;
                endcase
            end

            3'b011:begin
                case (Funct3)
                    3'h0: Operation = 5'd01;  // ADDI
                    
                    3'h7: Operation = 5'd05;  // ANDI
                    
                    3'h6: Operation = 5'd04;  // ORI
                    
                    3'h2: Operation = 5'd11;  // SLTI
                    
                    3'h1: Operation = 5'd07;  // SLLI
                    
                    3'h5: Operation = Funct7[5] ? 5'd08 : 5'd09;  // SRAI ou SRLI
						  
				    default: Operation = 5'd01;
                endcase
            end

            3'b100: Operation = 5'd12;

            3'b101: Operation = 5'd01;
                
            default: Operation = 5'd01;
        endcase
    end

endmodule
