# Instruction encoding
#
#  __________________________________________________________________
# | opcode | r_dest |  r_a  |  r_b  |        immediate val           |
#  ------------------------------------------------------------------
#    4-bit    4-bit    4-bit   4-bit            16-bit
#    <------------------    32-bit  --------------------------------->
#

import sys
import struct


def decode_register(reg, line_num):
    # reg = R0 or R1 or .... R15
    # input: R5 should give output: 0101
    num = int(reg[1:])
    if num > 15 or num < 0:
        raise Exception(f"line: {line_num} unknown register")
    num = bin(num)[2:]  # 5 becomes 0b101
    while len(num) != 4:
        num = '0' + num
    return num


def int_to_16bit_signed(value, line_num):
    if not -32768 <= value <= 32767:
        raise ValueError(
            f"line: {line_num} value out of range for 16-bit signed integer")
    # h = short datatype of c i.e 16-bits. In big-endian
    return struct.pack('>h', value)


def decode_immediate(number, line_num):
    number = int_to_16bit_signed(int(number), line_num)
    return ''.join(format(byte, '08b') for byte in number)


def decode_instruction(text, line_num, instruction_num, labels_map):
    text = text.split('//')[0].strip()
    codes = text.split()
    codes = [item.split(',')[0] for item in codes]

    takes_0_operand = ['HLT']
    takes_1_operand = ['JMP']
    takes_2_operands = ['MOV', 'MVI', 'NOT', 'JEZ', 'JNZ']
    takes_3_operands = ['LOD', 'STR', 'ADD',
                        'SUB', 'MUL', 'AND', 'ORR', 'LES', 'GTR']

    if codes[0] in takes_0_operand and len(codes) != 1:
        raise Exception(f"line: {line_num} {
                        codes[0]} doesn't take any operand")
    if codes[0] in takes_1_operand and len(codes) != 2:
        raise Exception(f"line: {line_num} {
                        codes[0]} takes one operand")
    if codes[0] in takes_2_operands and len(codes) != 3:
        raise Exception(f"line: {line_num} {
                        codes[0]} takes two operands")
    if codes[0] in takes_3_operands and len(codes) != 4:
        raise Exception(f"line: {line_num} {
                        codes[0]} takes three operands")

    opcode = '0000'
    r_dest = '0000'
    r_a = '0000'
    r_b = '0000'
    immediate = '0000' * 4
    unresolved = False

    match codes[0].upper():
        case "HLT":
            opcode = '0000'
        case "MOV":
            opcode = '0001'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
        case "MVI":
            opcode = '0010'
            r_dest = decode_register(codes[1], line_num)
            immediate = decode_immediate(codes[2], line_num)
        case "LOD":
            opcode = '0011'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            immediate = decode_immediate(codes[3], line_num)
        case "STR":
            opcode = '0100'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            immediate = decode_immediate(codes[3], line_num)
        case "ADD":
            opcode = '0101'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            r_b = decode_register(codes[3], line_num)
        case "SUB":
            opcode = '0110'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            r_b = decode_register(codes[3], line_num)
        case "MUL":
            opcode = '0111'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            r_b = decode_register(codes[3], line_num)
        case "AND":
            opcode = '1000'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            r_b = decode_register(codes[3], line_num)
        case "ORR":
            opcode = '1001'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            r_b = decode_register(codes[3], line_num)
        case "NOT":
            opcode = '1010'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
        case "LES":
            opcode = '1011'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            r_b = decode_register(codes[3], line_num)
        case "GTR":
            opcode = '1100'
            r_dest = decode_register(codes[1], line_num)
            r_a = decode_register(codes[2], line_num)
            r_b = decode_register(codes[3], line_num)
        case "JEZ":
            opcode = '1101'
            r_dest = decode_register(codes[1], line_num)
            if codes[2] not in labels_map:
                unresolved = True
            else:
                instr_to_jump = labels_map[codes[2]]
                offset = instr_to_jump - instruction_num
                immediate = decode_immediate(offset, line_num)
        case "JNZ":
            opcode = '1110'
            r_dest = decode_register(codes[1], line_num)
            if codes[2] not in labels_map:
                unresolved = True
            else:
                instr_to_jump = labels_map[codes[2]]
                offset = instr_to_jump - instruction_num
                immediate = decode_immediate(offset, line_num)
        case "JMP":
            opcode = '1111'
            if codes[1] not in labels_map:
                unresolved = True
            else:
                instr_to_jump = labels_map[codes[1]]
                offset = instr_to_jump - instruction_num
                immediate = decode_immediate(offset, line_num)
        case _:
            raise Exception(f"line: {line_num} unknown opcode")

    binary_debug = f"{opcode} {r_dest} {r_a} {r_b} {immediate}"
    instruction = int(opcode + r_dest + r_a + r_b + immediate, 2)
    return {
        'complete': not unresolved,
        'instruction': instruction,
        'binary_debug': binary_debug,
        'source': text,
        'line_num': line_num,
        'instruction_num': instruction_num
    }


def assembler(assembly_file):
    instructions = []
    labels_map = {}
    labels_reverse_map = {}
    with open(assembly_file, 'r') as file:
        for line_num, line in enumerate(file, start=1):
            line = line.strip()
            if len(line) == 0:
                continue
            elif len(line) > 0 and line[0] == '/':
                continue
            elif len(line) > 0 and line[0] == ':':
                label_name = line.split()[0][1:]
                instr_num = len(instructions)
                labels_map[label_name] = instr_num
                labels_reverse_map[instr_num] = label_name
            else:
                instructions.append(decode_instruction(
                    line, line_num, len(instructions), labels_map))

    instructions = [
        decode_instruction(item['source'], item['line_num'],
                           item['instruction_num'], labels_map)
        if not item['complete']
        else item
        for item in instructions
    ]

    print("\n" + "-"*27 + "  debug info  " + "-"*27)
    for i, inst in enumerate(instructions):
        line_num = f"#{i}"
        label = ""
        if i in labels_reverse_map:
            label = ":" + labels_reverse_map[i]
        src = inst['source']
        binary_debug = inst['binary_debug']
        LINE_NUM_LEN = 5
        LABEL_LEN = 10
        SRC_LEN = 18

        if len(line_num) < LINE_NUM_LEN:
            line_num = ' ' * (LINE_NUM_LEN - len(line_num)) + line_num
        if len(label) < LABEL_LEN:
            label = ' ' * (LABEL_LEN - len(label)) + label
        if len(src) < SRC_LEN:
            src = src + ' ' * (SRC_LEN - len(src))
        print(f"{line_num} {label}  {src}  {binary_debug}")

    print("\n----- assembled instructions -------")
    for inst in instructions:
        print(inst['instruction'])

    print("\n----- generated code -------")
    for i, inst in enumerate(instructions):
        print(f"computer.instruction_memory[{i}]={inst['instruction']};")


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 assembler assembly_src.s")
        exit(1)

    print(f"Assembling {sys.argv[1]} ---")
    assembler(sys.argv[1])
