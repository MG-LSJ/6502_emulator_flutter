import 'package:emulator/emulator/disassembler.dart';
import 'package:emulator/helpers/extensions.dart';
import 'package:emulator/runtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisassembledView extends ConsumerStatefulWidget {
  const DisassembledView({super.key});

  @override
  ConsumerState<DisassembledView> createState() => _DisassembledViewState();
}

class _DisassembledViewState extends ConsumerState<DisassembledView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(cpuClockNotifierProvider);
    ref.watch(memoryNotifierProvider);
    Map<int, DisassembledInstruction> disassembledInstructions = ref
        .watch(disassembledInstructionsNotifierProvider)
        .disassembledInstructions;

    const int instructionLenght = 26;
    const int halfInstructionLenght = instructionLenght ~/ 2;

    return SizedBox(
      width: 250,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: instructionLenght,
        itemBuilder: (BuildContext context, int index) {
          final int actualIndex =
              ((index - halfInstructionLenght) + (cpu.pc ~/ 2)) %
                  disassembledInstructions.length;

          return Container(
            padding: const EdgeInsets.all(1),
            color: cpu.pc ==
                    disassembledInstructions.entries.elementAt(actualIndex).key
                ? Colors.cyan
                : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  disassembledInstructions.entries
                      .elementAt(actualIndex)
                      .value
                      .address
                      .printHex(prefix: '0x'),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(disassembledInstructions.entries
                    .elementAt(actualIndex)
                    .value
                    .instruction),
                Text(disassembledInstructions.entries
                    .elementAt(actualIndex)
                    .value
                    .addressMode),
              ],
            ),
          );
        },
      ),
    );
  }
}
