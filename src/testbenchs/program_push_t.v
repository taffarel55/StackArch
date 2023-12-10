

wait(cpu_inst.controller.state == 13); // GET TEMP1
wait(cpu_inst.controller.state == 9); // PUSH STACK
$display("Valor %0d será salvo na pilha", cpu_inst.controller.data_to_stack);


