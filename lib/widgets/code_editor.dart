import 'dart:io';

import 'package:emulator/runtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:highlight/languages/armasm.dart';

class CodeEditorView extends ConsumerStatefulWidget {
  const CodeEditorView({super.key});

  @override
  ConsumerState<CodeEditorView> createState() => _CodeEditorViewState();
}

class _CodeEditorViewState extends ConsumerState<CodeEditorView> {
  CodeController controller = CodeController(
    text: """
  .org 0x8000  ;   start
start:
  ldx #0x0A    ;   load 10 into x
  stx 0x2500   ;   store 10 in memory location 2500
  ldx #0x03    ;   load 3 into x
  stx 0x2501   ;   store 3 in memory location 2501
  ldy 0x2500   ;   load 10 from memory location 2500 into y
  lda #0x00    ;   load 0 into a
  clc          ;   clear carry
loop:
  adc 0x2501   ;   add 3 to a
  dey          ;   decrement y
  bne loop     ;   branch if not equal to 0
  sta 0x2501   ;   store the result in memory location 2501

  .org 0xfffc  ;   reset vector
  .word start
  .word 0x0000
""",
    language: armasm,
  );

  @override
  void initState() {
    super.initState();
    _compile();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              CodeTheme(
                data: CodeThemeData(styles: atomOneLightTheme),
                child: CodeField(
                  controller: controller,
                  minLines: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        FilledButton(
          onPressed: _compile,
          child: const Text("Compile & Load"),
        ),
      ],
    );
  }

  void _compile() async {
    File file = File("src/temp.asm");
    await file.writeAsString("  .org 0x0000\n${controller.text}");

    var result = await Process.run("src/vasm6502_std.exe",
        ["-Fbin", "-quiet", "-x", "-o", "src/temp.bin", "src/temp.asm"]);
    if (result.exitCode == 0) {
      print("Compilation successful");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Compilation failed: ${result.stderr}"),
        ),
      );
      return;
    }

    File output = File("src/temp.bin");
    List<int> bytes = await output.readAsBytes();
    int offset = 0x0000;
    for (int i = 0; i < bytes.length; i++) {
      cpu.write(offset + i, bytes[i]);
    }
    cpu.reset();
    ref.read(memoryNotifierProvider).update();
    ref.read(disassembledInstructionsNotifierProvider).update();
    ref.read(cpuClockNotifierProvider).update();
  }
}
