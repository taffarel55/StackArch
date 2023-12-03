module fsm (
    input wire clk,
    input wire rst,

    // Temp regs
    output reg rst_temp1,
    output reg rst_temp2,
    output reg rd_temp1,
    output reg rd_temp2,
    output reg wr_temp1,
    output reg wr_temp2,

    // IR register
    output reg rd_ir,
    output reg wr_ir,
    output reg rst_ir,


    output reg rst_tos,

    // RFLAGs
    output reg rst_flags,

    // Data memory
    output reg rd_mem,
    output reg wr_mem,

    // Program counter
    output reg wr_ip,
    output reg rd_ip,
    output reg rst_ip,
    output reg inc_ip,

    // Data stack
    output reg push_stack,
    output reg pop_stack,
    output reg rst_stack,

    // Routine stack
    output reg push_rtn,
    output reg pop_rtn,
    output reg rst_rtn
  );
  // TODO: Verificar a necessidade de rst_stk e rst_tos

  // TODO: Concat + colocar isso como config global
  localparam RESET_ALL  = 0;
  localparam GET_INSTR  = 1;
  localparam SAVE_INSTR = 2;
  localparam DECODE     = 3;
  localparam SET_A      = 4;
  localparam SAVE_A     = 5;
  localparam SET_B      = 6;
  localparam SAVE_B     = 7;
  localparam VERIFY     = 8;
  localparam PUSH_STACK = 9;
  localparam JUMP       = 10;
  localparam PUSH_RTN   = 11;
  localparam RET_RTN    = 12;
  localparam GET_A      = 13;
  localparam READ_MEMD  = 14;
  localparam WRITE_MEMD = 15;
  localparam FINISH     = 16;
  localparam INC_IP     = 17;

  // TODO: Concat + colocar isso como config global
  localparam PUSH = 0;
  localparam PUSH_I = 1;
  localparam PUSH_T = 2;
  localparam POP = 3;
  localparam ADD = 4;
  localparam SUB = 5;
  localparam MUL = 6;
  localparam DIV = 7;
  localparam AND = 8;
  localparam NAND = 9;
  localparam OR = 10;
  localparam XOR = 11;
  localparam CMP = 12;
  localparam NOT = 13;
  localparam GOTO = 14;
  localparam IF_EQ = 15;
  localparam IF_GT = 16;
  localparam IF_LT = 17;
  localparam IF_GE = 18;
  localparam IF_LE = 19;
  localparam CALL = 20;
  localparam RET = 21;

  reg [5:0] state, next_state; // Mudar para parametros

  reg [15:0] instruction_register; // Mudar para parametros

  always @(posedge clk, posedge rst)
  begin : RESET_FSM
    if(rst)
      state <= RESET_ALL;
    else
      state <= next_state;
  end

  // TODO: Juntar cases, se tiver como
  // TODO: Colocar full case em case(instruction)
  // TODO: Mudar instruction_register[15:10] para uma variavel que represente a fatia da instrução
  always @(*)
  begin
    case (state)
      RESET_ALL:
        next_state = GET_INSTR;
      GET_INSTR:
        next_state = SAVE_INSTR;
      SAVE_INSTR:
        next_state = DECODE;
      DECODE:
      case (instruction_register[15:10])
        PUSH:
          next_state = READ_MEMD;
        PUSH_I:
          next_state = PUSH_STACK;
        PUSH_T:
          next_state = GET_A;
        POP,NOT: // ULA + POP
          next_state = SET_A;
        IF_EQ, IF_LE: // BRANCH
          next_state = SET_A;
        default:
          next_state = 0;
      endcase
      SET_A:
        next_state = instruction_register[15:10] == POP ? WRITE_MEMD : SAVE_A;
      SAVE_A:
      case(instruction_register[15:10])
        NOT:
          next_state = VERIFY;
        IF_EQ,IF_LE: // Jumps
          next_state = VERIFY;
        default:
          next_state = SET_B;
      endcase
      SET_B:
        next_state = SAVE_B;
      SAVE_B:
        next_state = VERIFY;
      VERIFY:
      case (instruction_register[15:10])
        ADD,NOT: // ULA
          next_state = PUSH_STACK;
        IF_EQ,IF_LE: // Jumps
          next_state = JUMP;
        default:
          next_state = FINISH;
      endcase
      PUSH_STACK:
        next_state = FINISH;
      JUMP:
        next_state = FINISH;
      PUSH_RTN:
        next_state = JUMP;
      RET_RTN:
        next_state = JUMP;
      GET_A:
        next_state = PUSH_STACK;
      READ_MEMD:
        next_state = PUSH_STACK;
      WRITE_MEMD:
        next_state = FINISH;
      FINISH:
        next_state = INC_IP;
      INC_IP:
        next_state = DECODE;
      default:
        next_state = RESET_ALL;
    endcase
  end

  always @(*)
  begin
    case (state)
      RESET_ALL:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        rst_flags   = 0;
        rst_ip      = 0;
        rst_ir      = 0;
        rst_rtn     = 0;
        rst_stack   = 0;
        rst_temp1   = 0;
        rst_temp2   = 0;
        rst_tos     = 0;
      end

      GET_INSTR:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        rd_mem = 1;
      end

      SAVE_INSTR:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        rd_mem = 1;
        wr_ir = 1;
      end

      DECODE:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        rd_ir = 1;
      end

      SET_A:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        pop_stack = 1;
      end

      SAVE_A:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        wr_temp1 = 1;
      end

      SET_B:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        pop_stack = 1;
      end

      SAVE_B:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        wr_temp2 = 1;
      end

      VERIFY:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA

      end

      PUSH_STACK:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        push_stack = 1;
      end

      JUMP:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        wr_ip = 1;
      end

      PUSH_RTN:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        push_rtn = 1;
        rd_ip = 1;
      end

      RET_RTN:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        pop_rtn = 1;
      end

      GET_A:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        rd_temp1 = 1;
      end

      READ_MEMD:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        rd_mem = 1;
      end

      WRITE_MEMD:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        wr_mem = 1;
      end

      FINISH:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA

      end

      INC_IP:
      begin
        // Temp regs
        rst_temp1 = 0;
        rst_temp2 = 0;
        rd_temp1 = 0;
        rd_temp2 = 0;
        wr_temp1 = 0;
        wr_temp2 = 0;

        // IR register
        rd_ir = 0;
        wr_ir = 0;
        rst_ir = 0;


        rst_tos = 0;

        // RFLAGs
        rst_flags = 0;

        // Data memory
        rd_mem = 0;
        wr_mem = 0;

        // Program counter
        wr_ip = 0;
        rd_ip = 0;
        rst_ip = 0;
        inc_ip = 0;

        // Data stack
        push_stack = 0;
        pop_stack = 0;
        rst_stack = 0;

        // Routine stack
        push_rtn = 0;
        pop_rtn = 0;
        rst_rtn = 0;

        // O A VERA
        inc_ip = 1;
      end

    endcase
  end

endmodule
