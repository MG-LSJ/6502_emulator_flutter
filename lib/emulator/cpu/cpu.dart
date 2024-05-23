import 'package:emulator/emulator/bus.dart';

part 'addressing_modes.dart';
part 'instructions.dart';
part 'flags.dart';
part 'base_class.dart';

class Cpu extends VirtualCpu with AddressingModesMixin, InstructionsMixin {
  Cpu(super.bus) {
    lookup = _getInstructions();
    reset();
  }

  @override
  void reset() {
    absAddress = 0xFFFC;

    final int low = read(absAddress);
    final int high = read(absAddress + 1);

    pc = (high << 8) | low;

    a = 0x00;
    x = 0x00;
    y = 0x00;
    sp = 0xFD;

    flags
      ..i = true // IRQ disabled
      ..d = false; // Decimal mode disabled
    // rest of the flags are unpredictable

    fetched = 0x00;
    absAddress = 0x0000;
    relAddress = 0x00;

    cycles = 8;
  }

  @override
  void irq() {
    if (flags.i) {
      write(0x0100 + sp, (pc >> 8) & 0x00FF);
      sp--;
      write(0x0100 + sp, pc & 0x00FF);
      sp--;

      flags
        ..b = false
        ..u = true
        ..i = true;

      write(0x0100 + sp, flags.status);
      sp--;

      absAddress = 0xFFFE;
      final int low = read(absAddress);
      final int high = read(absAddress + 1);
      pc = (high << 8) | low;

      cycles = 7;
    }
  }

  @override
  void nmi() {
    write(0x0100 + sp, (pc >> 8) & 0x00FF);
    sp--;
    write(0x0100 + sp, pc & 0x00FF);
    sp--;

    flags
      ..b = false
      ..u = true
      ..i = true;

    write(0x0100 + sp, flags.status);
    sp--;

    absAddress = 0xFFFA;
    final int low = read(absAddress);
    final int high = read(absAddress + 1);
    pc = (high << 8) | low;

    cycles = 8;
  }

  @override
  void clock() {
    if (cycles == 0) {
      opCode = read(pc);
      flags.u = true;
      pc++;

      final Instruction instruction = lookup[opCode];

      cycles = instruction.cycles;

      final int additionalCycle1 = instruction.addressMode();
      final int additionalCycle2 = instruction.operate();

      cycles += additionalCycle1 & additionalCycle2;
    }

    clockCount++;
    cycles--;
  }

  @override
  int fetch() {
    if (lookup[opCode].addressMode != imp) {
      fetched = read(absAddress);
    }

    return fetched;
  }

  @override
  bool complete() => cycles == 0;

  @override
  int read(int address) => bus.read(address);

  @override
  void write(int address, int data) => bus.write(address, data);
}
