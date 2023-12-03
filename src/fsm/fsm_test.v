
`include "src/fsm/fsm.v"
`timescale 1ns/1ps

module fsm_test;

  // Parameters

  //Ports
  reg  clk;
  reg  rst;
  wire  rst_temp1;
  wire  rst_temp2;
  wire  rd_temp1;
  wire  rd_temp2;
  wire  wr_temp1;
  wire  wr_temp2;
  wire  rd_ir;
  wire  wr_ir;
  wire  rst_ir;
  wire  rst_tos;
  wire  rst_flags;
  wire  rd_mem;
  wire  wr_mem;
  wire  wr_ip;
  wire  rd_ip;
  wire  rst_ip;
  wire  inc_ip;
  wire  push_stack;
  wire  pop_stack;
  wire  rst_stack;
  wire  push_rtn;
  wire  pop_rtn;
  wire  rst_rtn;

  fsm  fsm_inst (
         .clk(clk),
         .rst(rst),
         .rst_temp1(rst_temp1),
         .rst_temp2(rst_temp2),
         .rd_temp1(rd_temp1),
         .rd_temp2(rd_temp2),
         .wr_temp1(wr_temp1),
         .wr_temp2(wr_temp2),
         .rd_ir(rd_ir),
         .wr_ir(wr_ir),
         .rst_ir(rst_ir),
         .rst_tos(rst_tos),
         .rst_flags(rst_flags),
         .rd_mem(rd_mem),
         .wr_mem(wr_mem),
         .wr_ip(wr_ip),
         .rd_ip(rd_ip),
         .rst_ip(rst_ip),
         .inc_ip(inc_ip),
         .push_stack(push_stack),
         .pop_stack(pop_stack),
         .rst_stack(rst_stack),
         .push_rtn(push_rtn),
         .pop_rtn(pop_rtn),
         .rst_rtn(rst_rtn)
       );


  always #5  clk = ! clk ;

  initial
  begin
    // Create vcd
    $dumpfile("fsm.vcd");
    $dumpvars(0, fsm_test);

    clk = 0;

    @(negedge clk);
    rst = 1;
    @(negedge clk);
    rst = 0;

    #200;
    $finish;
  end

endmodule
