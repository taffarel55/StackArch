repeat(20)
begin
  wait(cpu_inst.controller.state == 3);
  $display("Executando a instrução %0d", cpu_inst.ip);
  wait(cpu_inst.controller.state != 3);
end

$display("TEST PASSED");
