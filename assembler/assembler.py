# Instruction encoding
#
#  __________________________________________________________________
# | opcode | r_dest |  r_a  |  r_b  |        immediate val           |
#  ------------------------------------------------------------------
#    4-bit    4-bit    4-bit   4-bit            16-bit
#    <------------------    32-bit  --------------------------------->
#


def opcode(code):
    match code.upper():
        case "HLT":
            return b'0000'
        case "MOV":
            return b'0001'
        case "MVI":
            return b'0010'
        case "LOD":
            return b'0011'
        case "STR":
            return b'0100'
        case "ADD":
            return b'0101'
        case "SUB":
            return b'0110'
        case "MUL":
            return b'0111'
        case "AND":
            return b'1000'
        case "ORR":
            return b'1001'
        case "NOT":
            return b'1010'
        case "LES":
            return b'1011'
        case "GTR":
            return b'1100'
        case "JEZ":
            return b'1101'
        case "JNZ":
            return b'1110'
        case "JMP":
            return b'1111'
        case _:
            raise Exception("unknown opcode")


def register(reg):
    # reg = R0 or R1 or .... R15


def assembler(assembly_source):
    return True
