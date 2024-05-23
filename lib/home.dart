import 'package:emulator/runtime.dart';
import 'package:emulator/widgets/code_editor.dart';
import 'package:emulator/widgets/disassembled_view.dart';
import 'package:emulator/widgets/raw_memory_view.dart';
import 'package:emulator/widgets/registers_row.dart';
import 'package:emulator/widgets/status_flags_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 8 - 10,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Memeory View",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                ref.read(memoryNotifierProvider).update();
                              },
                              icon: const Icon(Icons.refresh)),
                        ],
                      ),
                    ),
                  ),
                  const Expanded(
                    child: RawMemoryView(),
                  ),
                  const Text(
                    "Controls: SPACE to step one cycle",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 8 - 10,
              child: const Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Registers",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  RegistersRow(),
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        "Status Flags",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  StatusFlagsRow(),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 50,
                              child: Center(
                                child: Text(
                                  "Disassembled Code",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: DisassembledView()),
                          ],
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Code Editor",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: CodeEditorView()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
