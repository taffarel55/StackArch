repeat(5)
begin
  wait(cpu_inst.controller.state == 3);
  $display("Estou na instrução %d", cpu_inst.memory_program.addr);
  wait(cpu_inst.controller.state != 3);
end

#200;

$display("TEST PASSED");
