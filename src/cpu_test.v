`timescale 1ns/1ps
`include "src/cpu.v"
`include "src/testbenchs/list.v"

//-----------------------------------------//
// DEFINA O PROGRAMA A SER EXECUTADO AQUI: //
// ----------------------------------------//
`define PROGRAM_NAME "program_transfer_data"
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
    repeat(500)
    begin
      #1;
    end
    $display("TIMEOUT!");
    $finish;
  end

  initial
  begin
    // Create vcd
    $dumpfile("cpu.vcd");
    $dumpvars(0, cpu_test);

    clk = 0;

    rst = 1;
    @(negedge clk);
    rst = 0;

`ifdef PROGRAM_NAME
    `ifdef PROGRAM_TRANSFER_DATA
      `include "src/testbenchs/program_transfer_data.v"
    `endif

    // Outros programas vão aqui

`else
    `error "PROGRAM_NAME não definido ou vazio!"

`endif

    $finish;
  end

endmodule
