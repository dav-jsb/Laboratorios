// multiplier_control.sv
// FSM de controle da versao refinada do multiplicador
//
// Fluxograma da versao refinada (uma iteracao por ciclo):
//
//   1. Testar Product[0] (LSB do registrador product, equivale ao Multiplier0)
//   2. Se Product[0] == 1 ? Product[63:32] = Product[63:32] + Multiplicand
//      (passos 1 e 2 combinados com o shift no mesmo ciclo)
//   3. Shift Product a direita 1 bit (carry do passo 2 vai para Product[63])
//   4. 32a. repeticao? ? Sim: Fim | Nao: voltar ao passo 1
//
// Diferen�as em relacao a versao original:
//   - Estados ADD_OR_SKIP e SHIFT fundidos em COMPUTE (add + shift em 1 ciclo)
//   - multiplier_lsb nao e mais exposto pela FSM (testado internamente no datapath)
//   - product_wr e shift_en substituidos por compute_en
//   - Total: ~34 ciclos (1 LOAD + 32 COMPUTE + 1 DONE)
//     vs. ~66 ciclos da versao original (1 LOAD + 32�2 + 1 DONE)
//
// Estados:
//   IDLE    ? aguarda sinal 'start'
//   LOAD    ? carrega operandos no datapath (1 ciclo)
//   COMPUTE ? executa uma iteracao add+shift; repete 32 vezes (count 0..31)
//   DONE    ? sinaliza conclusao; retorna a IDLE quando 'start' � resetado

module multiplier_control (
    input  logic clk,
    input  logic rst_n,

    // Interface com o usuario
    input  logic start,
    output logic done,

    // Interface com o datapath
    output logic load,        // Carrega operandos iniciais
    output logic compute_en   // Executa uma iteracao (add condicional + shift)
);

    typedef enum logic [3:0] { // Estados da FSM (usando one-hot)
        IDLE = 4'b0001,
        LOAD = 4'b0010,
        COMPUTE = 4'b0100,
        DONE = 4'b1000
    } state_t;

    state_t state, next_state;

    logic [5:0] count; // Contador dos ciclos COMPUTE
    logic count_en; // Sinal do contador
    logic count_rst; // Sinal de reset do contador

    // Definição do funcionamento do contador
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) count <= '0;
        
        else if (count_rst) count <= '0;
        
        else if (count_en) count <= count + 6'd1;
    end

    // Troca de estados com base no clock ou no rst_n
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= IDLE;
        else state <= next_state;
    end

    // Bloco combinacional para determinação do próimo estado;
    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (start) next_state = LOAD;
            LOAD: next_state = COMPUTE;
            COMPUTE: begin
                if (count == 6'd31) next_state = DONE;
                else next_state = state;
            end
            DONE: if (!start) next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Bloco combinacional que define o que deve acontecer em cada estado
    always_comb begin
        // Determinação de valores base para as variáveis de controle
        load = 1'b0;
        compute_en = 1'b0;
        done = 1'b0;
        count_en = 1'b0;
        count_rst = 1'b0;

        case (state)
            IDLE: begin
                count_rst = 1'b1;
            end

            LOAD: begin
                load = 1'b1;
                count_rst = 1'b1;
            end

            COMPUTE: begin
                compute_en = 1'b1;
                count_en = 1'b1;
            end

            DONE: begin
                done = 1'b1;
            end

            default: ;
        endcase
    end

endmodule
