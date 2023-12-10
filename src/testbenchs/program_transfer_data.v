// Program = transfer_data

$display("\nColoca 4 valores da instrução (1,2,4,8) na pilha");
repeat(4)
begin
  wait(cpu_inst.controller.state == 9);
  $display("Empilhando %0d na posição %0d do ponteiro", cpu_inst.controller.operand, cpu_inst.stack_data.pointer);
  wait(cpu_inst.controller.state != 9);
end

$display("\nDesempilha estes valores salvando na memória em (4,5,7,15)");
repeat(4)
begin
  wait(cpu_inst.memory_data.wr);
  $display("Salvando %0d na posição %0d da memória | Ponteiro = %0d", cpu_inst.memory_data.data_in, cpu_inst.memory_data.addr, cpu_inst.stack_data.pointer);
  wait(!cpu_inst.memory_data.wr);
end

$display("\nEmpilha estes valores novamente da memória nos endereços (4,15,5,7)");
repeat(4)
begin
  wait(cpu_inst.controller.state == 9);
  $display("Empilhando %0d do endereço %0d da memória, na posição %0d do ponteiro", cpu_inst.controller.data_to_stack, cpu_inst.memory_data.addr, cpu_inst.stack_data.pointer);
  wait(cpu_inst.controller.state != 9);
end

#20;

$display("\nValores finais do ponteiro:");

final_value_test=0;
for(i=0; i<4; i=i+1)
begin
  $display("pointer[%0d] - %0d", i, cpu_inst.stack_data.lifo[i]);
  final_value_test = final_value_test + cpu_inst.stack_data.lifo[i]*10**i;
end

if(final_value_test === 2418)
begin
  $display("TEST PASSED");
end
else
begin
  $display("TEST NOT PASSED");
end

// ---- END PROGRAM -----
