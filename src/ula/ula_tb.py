
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import Timer
from cocotb.regression import TestFactory

@cocotb.test()
async def run_test(dut):
  PERIOD = 10

  dut.operand_a = 10
  dut.operand_b = 20
  dut.opcode = 0
  await Timer(20*PERIOD, units='ns')
  assert dut.out.value == 30

  dut.operand_a = 4
  dut.operand_b = 3
  dut.opcode = 1
  await Timer(20*PERIOD, units='ns')
  assert dut.out.value == 1

  dut.operand_a = 100
  dut.operand_b = 0
  dut.opcode = 4
  await Timer(20*PERIOD, units='ns')
  assert dut.out.value == 0

# Register the test.
factory = TestFactory(run_test)
factory.generate_tests()
