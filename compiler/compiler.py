class Compiler:
    def __init__(self):
        self.instructions = {
            'PUSH': 0,
            'PUSH_I': 1,
            'PUSH_T': 2,
            'POP': 3,
            'ADD': 4,
            'SUB': 5,
            'MUL': 6,
            'DIV': 7,
            'AND': 8,
            'NAND': 9,
            'OR': 10,
            'XOR': 11,
            'CMP': 12,
            'NOT': 13,
            'GOTO': 14,
            'IF_EQ': 15,
            'IF_GT': 16,
            'IF_LT': 17,
            'IF_GE': 18,
            'IF_LE': 19,
            'CALL': 20,
            'RET': 21
        }

        self.reverse_instructions = {v: k for k, v in self.instructions.items()}

    def assemble(self, mnemonic, operand=None):
        if mnemonic not in self.instructions:
            raise ValueError(f"Instrução desconhecida: {mnemonic}")

        opcode = self.instructions[mnemonic]

        if operand is not None:
            operand = self.validate_operand(operand)
            machine_code = (opcode << 11) | operand
        else:
            machine_code = opcode << 11

        return bin(machine_code)[2:].zfill(16)

    def validate_operand(self, operand):
        if operand < 0 or operand > 0b11111111111:
            raise ValueError("Operando inválido: deve ser um número de 11 bits")

        return operand

    def assemble_from_file(self, file_path):
        with open(file_path, 'r') as file:
            lines = file.readlines()
            lines_not_null = [line for line in lines if line.strip() != '']
            lines_not_commented = [line for line in lines_not_null if not line.startswith('//')]

        machine_code_lines = []
        for line in lines_not_commented:
            parts = line.strip().split()

            mnemonic = parts[0]
            
            operand = None
            if len(parts) > 1:
                if parts[1].startswith("0b"):
                    operand = int(parts[1][2:], 2)
                elif parts[1].startswith("0x"):
                    operand = int(parts[1][2:], 16)
                else:
                    operand = int(parts[1])

            machine_code = self.assemble(mnemonic, operand)
            machine_code_lines.append(machine_code)

        return machine_code_lines

    def write_machine_code_to_file(self, machine_code_lines, output_file):
        with open(output_file, 'w') as file:
            for code in machine_code_lines:
                operand = code[5:]
                intr_number = code[:5]
                instruction = f"{intr_number}_{operand}"

                opcode      = int(intr_number,2)
                name_instr  = self.reverse_instructions.get(opcode)

                comment = f"{name_instr} {int(operand,2)}"

                file.write(f"{instruction} // {comment}" + '\n')


# Exemplo de uso
compiler = Compiler()

import sys

if len(sys.argv) > 1:
    program_file = sys.argv[1]
else:
    print("Nenhum programa foi informado.")

file_path = program_file
machine_code_lines = compiler.assemble_from_file(file_path)

#for i, code in enumerate(machine_code_lines):
#    print(f'Instrução {i+1}: {code}')

output_file = program_file + ".bin"
compiler.write_machine_code_to_file(machine_code_lines, output_file)

#print(f'Código de máquina salvo em {output_file}')
