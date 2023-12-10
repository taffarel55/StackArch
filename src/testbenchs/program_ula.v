keys[4] = "ADD";
keys[5] = "SUB";
keys[6] = "MUL";
keys[7] = "DIV";
keys[8] = "AND";
keys[9] = "NAND";
keys[10] = "OR";
keys[11] = "XOR";
keys[12] = "CMP";
keys[13] = "NOT";

repeat(10)
begin
  wait(cpu_inst.controller.state == 8); // VERIFY
  $display("\n[TEST] %s", keys[cpu_inst.ula_inst.opcode]);
  $display("Salva %d como primeiro operando\t| bin = %b", cpu_inst.ula_inst.operand_a, cpu_inst.ula_inst.operand_a);
  $display("Salva %d como segundo operando\t| bin = %b", cpu_inst.ula_inst.operand_b, cpu_inst.ula_inst.operand_b);
  wait(cpu_inst.controller.state != 8);

  wait(cpu_inst.controller.state == 23); // GET_ULA
  $display("Obtém %d na saída da ULA\t| bin = %b", cpu_inst.ula_inst.out, cpu_inst.ula_inst.out);
  wait(cpu_inst.controller.state != 23);

  wait(cpu_inst.controller.state == 9); // PUSH_STACK
  $display("Empilhando %0d na posição %0d do ponteiro", cpu_inst.controller.data_to_stack, cpu_inst.stack_data.pointer);
  wait(cpu_inst.controller.state != 9);
end

$display("\nTEST PASSED");
