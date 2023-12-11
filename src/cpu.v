`include "src/memory/memory.v"
`include "src/fsm/fsm.v"
`include "src/register/register.v"
`include "src/stack/stack.v"
`include "src/ula/ula.v"

module cpu #(
    parameter PROGRAM_FILE = ""
  ) (
    input wire clk,
    input wire rst
  );

  wire [4:0] instruction;
  assign instruction = instr[15:11];

  wire [10:0] operand;
  assign operand = instr[10:0];

  // ---- IP -----
  wire [10:0] ip, in_ip;
  wire rst_ip, inc_ip, wr_ip;
  register #(.DATA_SIZE(11)) ip_regiser (.clk(clk), .rst(rst_ip), .out(ip), .inc(inc_ip), .load(wr_ip), .in(in_ip));


  // ---- IR -----
  wire wr_ir, rst_ir;
  wire [15:0] instr;
  register #(.DATA_SIZE(16)) ir_regiser (.clk(clk), .rst(rst_ir), .load(wr_ir), .in(fetched_instr), .out(instr));

  // ---- Stack Pointer -----
  localparam DEPTH_TOS_POINTER = 32;
  wire rst_stack, push_stack, pop_stack;
  wire [DEPTH_TOS_POINTER - 1:0] tos_pointer;
  wire [15:0] stack_data_in, stack_data_out;
  stack #(.WIDTH(16), .DEPTH(DEPTH_TOS_POINTER)) stack_data (
          .clk(clk),
          .rst(rst_stack),
          .pointer(tos_pointer),
          .push(push_stack),
          .pop(pop_stack),
          .data_in(stack_data_in),
          .data_out(stack_data_out)
        );

  // ----- Routine Stack -----
  wire push_rtn,pop_rtn,rst_rtn;
  wire [15:0] rtn_pointer;
  wire [10:0] out_rtn_stack;

  stack #(.WIDTH(11), .DEPTH(16)) routine_stack (
          .clk(clk),
          .rst(rst_rtn),
          .pointer(rtn_pointer),
          .push(push_rtn),
          .pop(pop_rtn),
          .data_in(ip),
          .data_out(out_rtn_stack)
        );

  // ---- FSM -----
  fsm  #(DEPTH_TOS_POINTER) controller (
         .clk(clk),
         .rst(rst),
         .wr_mem(wr_mem),
         .rd_mem(rd_mem),
         .wr_memd(wr_memd),
         .rd_memd(rd_memd),
         .data_out_memd(data_out_memd),
         .rst_ip(rst_ip),
         .inc_ip(inc_ip),
         .wr_ip(wr_ip),
         .actual_addr_inst(in_ip),
         .rst_ir(rst_ir),
         .wr_ir(wr_ir),
         .rst_stack(rst_stack),
         .tos_pointer(tos_pointer),
         .push_stack(push_stack),
         .pop_stack(pop_stack),
         .stack_data_in(stack_data_in),
         .stack_data_out(stack_data_out),
         .instruction(instruction),
         .operand(operand),
         .out_ula(out_ula),
         .temp1(temp1),
         .temp2(temp2),
         .push_rtn(push_rtn),
         .pop_rtn(pop_rtn),
         .rst_rtn(rst_rtn),
         .rtn_pointer(rtn_pointer),
         .out_rtn_stack(out_rtn_stack)
       );

  // ---- Program Memory -----
  wire [15:0] fetched_instr;
  wire wr_mem, rd_mem;
  memory
    #(
      .AWIDTH (11),
      .DWIDTH (16),
      .INIT_MEMORY (PROGRAM_FILE)
    )
    memory_program
    (
      .wr(wr_mem),
      .rd (rd_mem),
      .addr(ip),
      .data_out(fetched_instr)
    );

  // ---- Data Memory -----
  wire wr_memd, rd_memd;
  wire [15:0] data_out_memd;
  memory
    #(
      .AWIDTH (11),
      .DWIDTH (16)
    )
    memory_data
    (
      .wr(wr_memd),
      .rd (rd_memd),
      .addr(operand),
      .data_in(stack_data_out),
      .data_out(data_out_memd)
    );

  // ---- ULA -----
  wire [15:0] out_ula, temp1, temp2;
  ula
    #(
      .DATA_SIZE(16)
    )
    ula_inst
    (
      .out(out_ula),
      .operand_a(temp1),
      .operand_b(temp2),
      .opcode(instruction[3:0])
    );



endmodule
