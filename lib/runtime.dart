import 'package:emulator/emulator/bus.dart';
import 'package:emulator/emulator/cpu/cpu.dart';
import 'package:emulator/emulator/disassembler.dart';
import 'package:emulator/emulator/ram.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Cpu cpu = Cpu(Bus(Ram())); // CPU instance

class CpuClockNotifier extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class MemeoryNotifier extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class RegistersNotifier extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}

class FlagsNotifier extends ChangeNotifier {
  void notify() {
    notifyListeners();
  }
}

class DisassembledInstructionsNotifier extends ChangeNotifier {
  Map<int, DisassembledInstruction> disassembledInstructions =
      disassemble(cpu, 0x0000, cpu.bus.ram.size);

  void update() {
    disassembledInstructions = disassemble(cpu, 0x0000, cpu.bus.ram.size);
    notifyListeners();
  }
}

final cpuClockNotifierProvider =
    ChangeNotifierProvider((ref) => CpuClockNotifier());
final memoryNotifierProvider =
    ChangeNotifierProvider((ref) => MemeoryNotifier());
final registersNotifierProvider =
    ChangeNotifierProvider((ref) => RegistersNotifier());
final flagsNotifierProvider = ChangeNotifierProvider((ref) => FlagsNotifier());
final disassembledInstructionsNotifierProvider =
    ChangeNotifierProvider((ref) => DisassembledInstructionsNotifier());
