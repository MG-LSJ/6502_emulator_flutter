import 'package:emulator/helpers/extensions.dart';
import 'package:emulator/runtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistersRow extends ConsumerStatefulWidget {
  const RegistersRow({super.key});

  @override
  ConsumerState<RegistersRow> createState() => _RegistersRowState();
}

class _RegistersRowState extends ConsumerState<RegistersRow> {
  TextEditingController aRegisterTextEditingController =
      TextEditingController(text: cpu.a.printHex(precision: 2));
  TextEditingController xRegisterTextEditingController =
      TextEditingController(text: cpu.x.printHex(precision: 2));
  TextEditingController yRegisterTextEditingController =
      TextEditingController(text: cpu.y.printHex(precision: 2));
  TextEditingController pcRegisterTextEditingController =
      TextEditingController(text: cpu.pc.printHex(precision: 4));
  TextEditingController spRegisterTextEditingController =
      TextEditingController(text: cpu.sp.printHex(precision: 2));

  @override
  void initState() {
    super.initState();

    aRegisterTextEditingController.addListener(() {
      if (aRegisterTextEditingController.text.isNotEmpty) {
        cpu.a = int.parse(aRegisterTextEditingController.text, radix: 16);
      }
    });

    xRegisterTextEditingController.addListener(() {
      if (xRegisterTextEditingController.text.isNotEmpty) {
        cpu.x = int.parse(xRegisterTextEditingController.text, radix: 16);
      }
    });

    yRegisterTextEditingController.addListener(() {
      if (yRegisterTextEditingController.text.isNotEmpty) {
        cpu.y = int.parse(yRegisterTextEditingController.text, radix: 16);
      }
    });

    pcRegisterTextEditingController.addListener(() {
      if (pcRegisterTextEditingController.text.isNotEmpty) {
        cpu.pc = int.parse(pcRegisterTextEditingController.text, radix: 16);
      }
    });

    spRegisterTextEditingController.addListener(() {
      if (spRegisterTextEditingController.text.isNotEmpty) {
        cpu.sp = int.parse(spRegisterTextEditingController.text, radix: 16);
      }
    });
  }

  @override
  void dispose() {
    aRegisterTextEditingController.dispose();
    xRegisterTextEditingController.dispose();
    yRegisterTextEditingController.dispose();
    pcRegisterTextEditingController.dispose();
    spRegisterTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(cpuClockNotifierProvider);

    aRegisterTextEditingController.text = cpu.a.printHex(precision: 2);
    xRegisterTextEditingController.text = cpu.x.printHex(precision: 2);
    yRegisterTextEditingController.text = cpu.y.printHex(precision: 2);
    pcRegisterTextEditingController.text = cpu.pc.printHex(precision: 4);
    spRegisterTextEditingController.text = cpu.sp.printHex(precision: 2);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildRegister(
          textEditingController: aRegisterTextEditingController,
          register: 'A',
        ),
        const SizedBox(width: 10),
        _buildRegister(
          textEditingController: xRegisterTextEditingController,
          register: 'X',
        ),
        const SizedBox(width: 10),
        _buildRegister(
          textEditingController: yRegisterTextEditingController,
          register: 'Y',
        ),
        const SizedBox(width: 10),
        _buildRegister(
          textEditingController: pcRegisterTextEditingController,
          register: 'PC',
          bytes: 4,
          editable: false,
        ),
        const SizedBox(width: 10),
        _buildRegister(
          textEditingController: spRegisterTextEditingController,
          register: 'SP',
          editable: false,
        ),
      ],
    );
  }
}

Widget _buildRegister({
  required TextEditingController textEditingController,
  required String register,
  bool editable = true,
  int bytes = 2,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        "$register: ",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const Text(
        "0x",
        style: TextStyle(
          fontSize: 16,
          color: Colors.black45,
        ),
      ),
      ...(editable
          ? [
              SizedBox(
                width: 25,
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.all(0),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  maxLength: bytes,
                  maxLines: 1,
                  minLines: 1,
                  textAlign: TextAlign.center,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                  expands: false,
                  controller: textEditingController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]')),
                  ],
                ),
              ),
              Text(
                "(${int.parse(textEditingController.text, radix: 16)})",
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ]
          : [
              Text(
                textEditingController.text,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ])
    ],
  );
}
