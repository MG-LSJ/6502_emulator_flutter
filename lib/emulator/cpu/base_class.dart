part of 'cpu.dart';

mixin Helpers {
  int fetched = 0x00; // Represents the working input value to the ALU
  int absAddress = 0x0000; // All used memory addresses end up in here
  int relAddress = 0x00; // Represents absolute address following a branch
  int opCode = 0x00; // Is the instruction byte

  int cycles = 0; // Counts how many cycles the instruction has remaining
  int clockCount = 0; // A global accumulation of the number of clocks
  bool complete(); // A flag to indicate the instruction has completed
  late final List<Instruction>
      lookup; // A lookup table with all the instructions
}

abstract class VirtualCpu with Helpers {
  int a = 0x00; // Accumulator Register
  int x = 0x00; // X Register
  int y = 0x00; // Y Register
  int pc = 0x0000; // Program Counter
  int sp = 0x00; // Stack Pointer

  final Bus bus;
  final Flags flags = Flags();

  VirtualCpu(this.bus);

  void reset();
  void irq();
  void nmi();
  void clock();
  int fetch();
  int read(int address);
  void write(int address, int data);
}
