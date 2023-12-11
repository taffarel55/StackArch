`timescale 1ns/1ps
`include "src/cpu.v"

//-----------------------------------------//
// DEFINA O PROGRAMA A SER EXECUTADO AQUI: //
// ----------------------------------------//
`define PROGRAM_NAME "program_fibonacci_n"
// ------------------------------------------

module cpu_test;

  // Parameters
  localparam PROGRAM_FILE = {"../src/programs/",`PROGRAM_NAME,".txt"};

  //Ports
  reg  clk;
  reg  rst;

  cpu # (
        .PROGRAM_FILE(PROGRAM_FILE)
      )
      cpu_inst (
        .clk(clk),
        .rst(rst)
      );

  always #1  clk = ! clk ;

  integer i = 0;
  reg [31:0] final_value_test;

  initial
  begin
    repeat(1000)
    begin
      #1;
    end
    $display("TIMEOUT!");
    $finish;
  end

  reg [31:0] keys [4:13];

  initial
  begin
    // Create vcd
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_test);

    clk = 0;

    rst = 1;
    @(negedge clk);
    rst = 0;

    //------------------------------------------//
    // DEFINA O TESTBENCH A SER EXECUTADO AQUI: //
    // -----------------------------------------//
    `include "src/testbenchs/program_fibonacci_n.v"
    // ------------------------------------------


    $finish;
  end

endmodule
