part of 'cpu.dart';

mixin AddressingModesMixin on VirtualCpu {
  // Addressing Modes --------------------------

  int imp() {
    fetched = a;

    return 0;
  }

  int imm() {
    absAddress = pc++;

    return 0;
  }

  int zp0() {
    absAddress = read(pc);
    pc++;
    absAddress &= 0x00FF;

    return 0;
  }

  int zpx() {
    absAddress = read(pc) + x;
    pc++;
    absAddress &= 0x00FF;

    return 0;
  }

  int zpy() {
    absAddress = read(pc) + y;
    pc++;
    absAddress &= 0x00FF;

    return 0;
  }

  int rel() {
    relAddress = read(pc);
    pc++;

    if (relAddress & 0x80 != 0) {
      relAddress |= 0xFF00;
    }

    return 0;
  }

  int abs() {
    final int low = read(pc);
    pc++;
    final int high = read(pc);
    pc++;

    absAddress = (high << 8) | low;

    return 0;
  }

  int abx() {
    final int low = read(pc);
    pc++;
    final int high = read(pc);
    pc++;

    absAddress = (high << 8) | low;
    absAddress += x;

    return ((absAddress & 0xFF00) != (high << 8)) ? 1 : 0;
  }

  int aby() {
    final int low = read(pc);
    pc++;
    final int high = read(pc);
    pc++;

    absAddress = (high << 8) | low;
    absAddress += y;

    return ((absAddress & 0xFF00) != (high << 8)) ? 1 : 0;
  }

  int ind() {
    final int pointerLow = read(pc);
    pc++;
    final int pointerHigh = read(pc);
    pc++;

    final int pointer = (pointerHigh << 8) | pointerLow;

    if (pointerLow == 0x00FF) {
      absAddress = (read(pointer & 0xFF00) << 8) | read(pointer);
    } else {
      absAddress = (read(pointer + 1) << 8) | read(pointer);
    }

    return 0;
  }

  int izx() {
    final int tempPc = read(pc);
    pc++;

    final int low = read((tempPc + x) & 0x00FF);
    final int high = read((tempPc + x + 1) & 0x00FF);

    absAddress = (high << 8) | low;

    return 0;
  }

  int izy() {
    final int tempPc = read(pc);
    pc++;

    final int low = read(tempPc & 0x00FF);
    final int high = read((tempPc + 1) & 0x00FF);

    absAddress = (high << 8) | low;
    absAddress += y;

    return ((absAddress & 0xFF00) != (high << 8)) ? 1 : 0;
  }
}
