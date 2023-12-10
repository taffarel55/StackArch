module fsm #(
    parameter integer DEPTH_TOS_POINTER = 32
  )(
    input wire clk,
    input wire rst,
    input wire [4:0] instruction,
    input wire [10:0] operand,

    input wire [15:0] stack_data_out,
    output reg [15:0] stack_data_in,

    // ULA
    input [15:0] out_ula,
    output reg [15:0] temp1,
    output reg [15:0] temp2,

    // IR register
    output reg rd_ir,
    output reg wr_ir,
    output reg rst_ir,

    output reg rst_tos,

    // RFLAGs
    output reg rst_flags,

    // Program memory
    output reg rd_mem,
    output reg wr_mem,

    // Data memory
    output reg rd_memd,
    output reg wr_memd,
    input wire [15:0] data_out_memd,

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
    output reg rst_rtn,

    // Pointer to data stack
    output reg [DEPTH_TOS_POINTER - 1:0] tos_pointer
  );

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
  localparam PREP_MEMD  = 18;
  localparam PREP_IMM   = 19;
  localparam INC_STACK  = 20;
  localparam DEC_STACK  = 21;
  localparam DEC_STACK_AGAIN = 22;
  localparam GET_ULA    = 23;

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


  wire isULA, isJUMP;
  assign isULA = instruction>=ADD && instruction<=NOT;
  assign isJUMP = instruction>=IF_EQ && instruction<=IF_LE;

  reg [5:0] state, next_state;
  reg [15:0] data_to_stack;


  always @(posedge clk, posedge rst)
  begin : RESET_FSM
    if(rst)
      state <= RESET_ALL;
    else
      state <= next_state;
  end

  always @*
  begin
    case (state)
      RESET_ALL:
        next_state = GET_INSTR;
      GET_INSTR:
        next_state = SAVE_INSTR;
      SAVE_INSTR:
        next_state = DECODE;
      DECODE:
      begin
        case (instruction)
          PUSH:
            next_state = READ_MEMD;
          PUSH_I:
            next_state = PREP_IMM;
          PUSH_T:
            next_state = GET_A;
          POP, ADD, SUB, MUL, DIV, AND,
          NAND, OR, XOR, CMP, NOT,IF_EQ,
          IF_GT, IF_LT, IF_GE, IF_LE:
            next_state = SET_A;
          GOTO:
            next_state = JUMP;
          CALL:
            next_state = PUSH_RTN;
          RET:
            next_state = RET_RTN;
          default:
            next_state = 0;
        endcase
      end
      SET_A:
        next_state = DEC_STACK;
      DEC_STACK:
        next_state = instruction == POP ? WRITE_MEMD : SAVE_A;
      SAVE_A:
      case(instruction)
        NOT:
          next_state = VERIFY;
        IF_EQ,IF_LE: // Jumps
          next_state = VERIFY;
        default:
          next_state = SET_B;
      endcase
      SET_B:
        next_state = DEC_STACK_AGAIN;
      DEC_STACK_AGAIN:
        next_state = SAVE_B;
      SAVE_B:
        next_state = VERIFY;
      VERIFY:
      case (1)
        isULA:
          next_state = GET_ULA;
        isJUMP:
          next_state = JUMP;
        default:
          next_state = FINISH;
      endcase
      GET_ULA:
        next_state <= PUSH_STACK;
      PREP_IMM:
        next_state = PUSH_STACK;
      PUSH_STACK:
        next_state = INC_STACK;
      JUMP:
        next_state = FINISH;
      PUSH_RTN:
        next_state = JUMP;
      RET_RTN:
        next_state = JUMP;
      GET_A:
        next_state = PUSH_STACK;
      READ_MEMD:
        next_state = PREP_MEMD;
      PREP_MEMD:
        next_state = PUSH_STACK;
      WRITE_MEMD:
        next_state = FINISH;
      FINISH:
        next_state = INC_IP;
      INC_IP:
        next_state = GET_INSTR;
      INC_STACK:
        next_state = FINISH;
      default:
        next_state = RESET_ALL;
    endcase
  end

  always @*
  begin
    // IR register
    rd_ir = 0;
    wr_ir = 0;
    rst_ir = 0;

    rst_tos = 0;

    // RFLAGs
    rst_flags = 0;

    // Data memory
    rd_memd = 0;
    wr_memd = 0;

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

    case (state)
      RESET_ALL:
      begin
        rst_flags   = 1;
        rst_ip      = 1;
        rst_ir      = 1;
        rst_rtn     = 1;
        rst_stack   = 1;
        temp1 = 0;
        temp2 = 0;

        tos_pointer = 0;
      end

      GET_INSTR:
      begin
        rd_mem = 1;
      end

      SAVE_INSTR:
      begin
        rd_mem = 1;
        wr_ir = 1;
      end

      DECODE:
      begin
        rd_ir = 1;
      end

      SET_A:
      begin
        pop_stack = 1;
      end

      DEC_STACK:
      begin
        tos_pointer = tos_pointer - 1;
      end

      SAVE_A:
      begin
        temp1 = stack_data_out;
      end

      SET_B:
      begin
        pop_stack = 1;
      end

      DEC_STACK_AGAIN:
      begin
        tos_pointer = tos_pointer - 1;
      end

      SAVE_B:
      begin
        temp2 = stack_data_out;
      end

      VERIFY:
      begin

      end

      GET_ULA:
      begin
        data_to_stack = out_ula;
      end

      PUSH_STACK:
      begin
        // TODO: tá cheio??
        stack_data_in = data_to_stack;
        push_stack = 1;
      end

      JUMP:
      begin
        wr_ip = 1;
      end

      PUSH_RTN:
      begin
        push_rtn = 1;
        rd_ip = 1;
      end

      RET_RTN:
      begin
        pop_rtn = 1;
      end

      GET_A:
      begin
        data_to_stack = temp1;
      end

      READ_MEMD:
      begin
        rd_memd = 1;
      end

      PREP_IMM:
      begin
        data_to_stack = operand;
      end

      PREP_MEMD:
      begin
        rd_memd = 1;
        data_to_stack = data_out_memd;
      end

      WRITE_MEMD:
      begin
        wr_memd = 1;
      end

      FINISH:
      begin


      end

      INC_IP:
      begin
        inc_ip = 1;
      end

      INC_STACK:
      begin
        tos_pointer = tos_pointer + 1;
      end

    endcase
  end

endmodule
