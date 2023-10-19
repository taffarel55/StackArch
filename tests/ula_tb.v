`include "vunit_defines.svh"
`include "src/ula/ula.v"

module ula_tb;

  // Parameters
  localparam    DATA_SIZE = 11;

  //Ports
  wire [DATA_SIZE-1:0]    out;
  reg [DATA_SIZE-1:0] operand_a;
  reg [DATA_SIZE-1:0] operand_b;
  reg [3:0] opcode;

  ula # (
        .DATA_SIZE(DATA_SIZE)
      ) ula_inst (
        .out(out),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .opcode(opcode)
      );

  localparam  ADD  = 0; //! A+B
  localparam  SUB  = 1; //! A-B
  localparam  MUL  = 2; //! A*B
  localparam  DIV  = 3; //! A/B
  localparam  AND  = 4; //! A AND B
  localparam  NAND = 5; //! A NAND B
  localparam  OR   = 6; //! A OR B
  localparam  XOR  = 7; //! A XOR B
  localparam  CMP  = 8; //! 1:A>B, 0:A=B, -1:A<B
  localparam  NOT  = 9; //! !A

  integer delay;
  integer seed = 42;

  initial
    `TEST_SUITE
    begin
      $dumpfile("ula_tb.vcd");
      $dumpvars(0, ula_tb);

      // ADD
      opcode = ADD;
      operand_a = $random(seed);
      operand_b = $random;
      #2;

      `TEST_CASE("Testando AND")
                begin
                  opcode = AND;
                  operand_a = 0;
                  operand_b = $random;
                  `CHECK_EQUAL(out, 1);
                  #2;
                end
                `TEST_CASE("Testando OR")
                          begin
                            opcode = OR;
                            operand_a = 11'b10101010101;
                            operand_b = 11'b01010101010;
                            #2;
                            `CHECK_EQUAL(1, 1);
                          end


                          // NAND
                          opcode = OR;
      operand_a = 11'b10101010101;
      operand_b = 11'b01010101010;
      #2;



      $finish;
    end

  endmodule

