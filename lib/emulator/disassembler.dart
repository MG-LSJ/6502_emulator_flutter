import 'package:emulator/emulator/cpu/cpu.dart';
import 'package:emulator/helpers/extensions.dart';

class DisassembledInstruction {
  int address;
  String instruction;
  String addressMode;

  DisassembledInstruction(
      {this.address = 0, this.instruction = '', this.addressMode = ''});
}

Map<int, DisassembledInstruction> disassemble(Cpu cpu, int start, int stop) {
  final Map<int, DisassembledInstruction> result =
      <int, DisassembledInstruction>{};

  final List<Instruction> lookup = cpu.lookup;

  int address = start;
  int value = 0x00;
  int low = 0x00;
  int high = 0x00;
  int lineAddress = 0;

  while (address <= stop) {
    lineAddress = address;

    final int opCode = cpu.read(address);
    final int Function() addressMode = lookup[opCode].addressMode;

    result[lineAddress] = DisassembledInstruction(
      address: address,
      instruction: "${lookup[opCode].name} ",
    );
    address++;
    if (addressMode == cpu.imp) {
      result[lineAddress]?.addressMode = 'IMP';
    } else if (addressMode == cpu.imm) {
      value = cpu.read(address);
      address++;
      result[lineAddress]?.instruction +=
          "${value.printHex(precision: 2, prefix: '0x')} ($value)";
      result[lineAddress]?.addressMode = 'IMM';
    } else if (addressMode == cpu.zp0) {
      low = cpu.read(address);
      address++;
      high = 0x00;
      result[lineAddress]?.instruction +=
          low.printHex(precision: 2, prefix: '0x');
      result[lineAddress]?.addressMode = 'ZP0';
    } else if (addressMode == cpu.zpx) {
      low = cpu.read(address);
      address++;
      high = 0x00;
      result[lineAddress]?.instruction +=
          low.printHex(precision: 2, prefix: '0x');
      result[lineAddress]?.addressMode = 'ZPX';
    } else if (addressMode == cpu.zpy) {
      low = cpu.read(address);
      address++;
      high = 0x00;
      result[lineAddress]?.instruction +=
          low.printHex(precision: 2, prefix: '0x');
      result[lineAddress]?.addressMode = 'ZPY';
    } else if (addressMode == cpu.izx) {
      low = cpu.read(address);
      address++;
      high = 0x00;
      result[lineAddress]?.instruction +=
          '(${low.printHex(precision: 2, prefix: '0x')}, X)';
      result[lineAddress]?.addressMode = 'IZX';
    } else if (addressMode == cpu.izy) {
      low = cpu.read(address);
      address++;
      high = 0x00;
      result[lineAddress]?.instruction +=
          '(${low.printHex(precision: 2, prefix: '0x')}, Y)';
      result[lineAddress]?.addressMode = 'IZY';
    } else if (addressMode == cpu.abs) {
      low = cpu.read(address);
      address++;
      high = cpu.read(address);
      address++;
      result[lineAddress]?.instruction +=
          (high << 8 | low).printHex(prefix: '0x');
      result[lineAddress]?.addressMode = 'ABS';
    } else if (addressMode == cpu.abx) {
      low = cpu.read(address);
      address++;
      high = cpu.read(address);
      address++;
      result[lineAddress]?.instruction +=
          (high << 8 | low).printHex(prefix: '0x');
      result[lineAddress]?.addressMode = 'ABX';
    } else if (addressMode == cpu.aby) {
      low = cpu.read(address);
      address++;
      high = cpu.read(address);
      address++;
      result[lineAddress]?.instruction +=
          (high << 8 | low).printHex(prefix: '0x');
      result[lineAddress]?.addressMode = 'ABY';
    } else if (addressMode == cpu.ind) {
      low = cpu.read(address);
      address++;
      high = cpu.read(address);
      address++;
      result[lineAddress]?.instruction +=
          '(${(high << 8 | low).printHex(prefix: '0x')})';
      result[lineAddress]?.addressMode = 'IND';
    } else if (addressMode == cpu.rel) {
      value = cpu.read(address);
      address++;
      result[lineAddress]?.instruction +=
          value.printHex(precision: 2, prefix: '0x');
      result[lineAddress]?.addressMode = 'REL';
    }
  }
  return result;
}
