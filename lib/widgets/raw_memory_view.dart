import 'package:flutter/material.dart';
import 'package:emulator/helpers/extensions.dart';
import 'package:emulator/runtime.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const int offset = 0x8000;

class RawMemoryView extends ConsumerStatefulWidget {
  const RawMemoryView({super.key});

  @override
  ConsumerState<RawMemoryView> createState() => _RawMemoryViewState();
}

class _RawMemoryViewState extends ConsumerState<RawMemoryView> {
  int memoryViewStartAddress = 0x0000;
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    ref.watch(memoryNotifierProvider);
    bool greyFlag = true;
    return Column(
      children: [
        Row(
          children: [
            const Text("Start Address: "),
            DropdownButton<int>(
              value: memoryViewStartAddress,
              items: List.generate(0x10, (int index) {
                int val = index * 0x1100;
                return DropdownMenuItem<int>(
                  value: val,
                  child: Text(val.printHex(precision: 4, prefix: '0x')),
                );
              }),
              onChanged: (int? value) {
                setState(() {
                  memoryViewStartAddress = value!;
                });
              },
            ),
            Slider.adaptive(
              value: sliderValue,
              mouseCursor: (memoryViewStartAddress != 0xFF00)
                  ? SystemMouseCursors.click
                  : MouseCursor.defer,
              onChanged: (double value) {
                if ((memoryViewStartAddress != 0xFF00)) {
                  setState(() {
                    sliderValue = value;
                  });
                }
              },
              min: 0x00,
              max: 0x10,
              divisions: 0x10,
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              width: 100,
              child: TextField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 4,
                minLines: 1,
                maxLines: 1,
                scrollPhysics: const NeverScrollableScrollPhysics(),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  counterText: '',
                  alignLabelWithHint: true,
                ),
                onChanged: (String value) {
                  if (value.length == 4) {
                    int addr = int.parse(value, radix: 16);
                    if (addr >= 0 && addr <= 0xFFFF) {
                      memoryViewStartAddress = (addr ~/ 0x1100) * 0x1100;
                      sliderValue = (addr - memoryViewStartAddress) / 0x0100;
                      setState(() {});
                    }
                  }
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 16,
            itemBuilder: (BuildContext context, int rowIndex) {
              greyFlag = !greyFlag;
              return Container(
                color: greyFlag ? Colors.grey[300] : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (memoryViewStartAddress +
                                (memoryViewStartAddress != 0xFF00
                                    ? sliderValue.toInt() * 0x0100
                                    : 0) +
                                rowIndex * 16)
                            .printHex(precision: 4, prefix: '0x'),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...List.generate(16, (columnIndex) {
                        int addr = memoryViewStartAddress +
                            (memoryViewStartAddress != 0xFF00
                                ? sliderValue.toInt() * 0x0100
                                : 0) +
                            rowIndex * 16 +
                            columnIndex;

                        final TextEditingController controller =
                            TextEditingController();
                        controller.text =
                            (cpu.read(addr)).printHex(precision: 2, prefix: '');

                        return SizedBox(
                          width: 25,
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: controller,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.all(0)),
                            expands: false,
                            maxLength: 2,
                            minLines: 1,
                            maxLines: 1,
                            scrollPhysics: const NeverScrollableScrollPhysics(),
                            keyboardType: TextInputType.number,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {});
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9a-fA-F]')),
                            ],
                            onChanged: (String value) {
                              if (value.length == 2) {
                                int data = int.parse(value, radix: 16);
                                cpu.write(addr, data);
                                ref.read(memoryNotifierProvider).update();
                                ref
                                    .read(
                                        disassembledInstructionsNotifierProvider)
                                    .update();
                                setState(() {});
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
