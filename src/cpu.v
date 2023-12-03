`include "src/memory/memory.v"
`include "src/fsm/fsm.v"
`include "src/register/register.v"

module cpu #(
    parameter PROGRAM_FILE = ""
  ) (
    input wire clk,
    input wire rst
  );

  // ---- IP -----
  wire [9:0] ip;
  wire rst_ip;

  register #(.DATA_SIZE(10)) ip_regiser (.clk(clk), .rst(rst_ip), .out(ip));
  // --------------

  // ---- IR -----
  wire wr_ir, rst_ir;
  wire [15:0] instr;

  register #(.DATA_SIZE(16)) ir_regiser (.clk(clk), .rst(rst_ir), .load(wr_ir), .in(fetched_instr), .out(instr));
  // --------------


  // ---- FSM -----
  fsm controller (
        .clk(clk),
        .rst(rst),
        .wr_mem(wr_mem),
        .rd_mem(rd_mem),
        .rst_ip(rst_ip),
        .rst_ir(rst_ir),
        .wr_ir(wr_ir),
        .instruction_register(instr)
      );
  // --------------

  // ---- Program Memory -----
  wire [15:0] fetched_instr;
  wire wr_mem, rd_mem;
  memory
    #(
      .AWIDTH (10),
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
  // --------------


endmodule
