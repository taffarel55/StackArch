`include "src/cpu.v"
`timescale 1ns/1ps

module cpu_test;

  // Parameters
  localparam PROGRAM_FILE = "../src/program.txt";

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

  initial
  begin
    // Create vcd
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_test);

    clk = 0;

    rst = 1;
    @(negedge clk);
    rst = 0;

    #30;
    $finish;
  end

endmodule
