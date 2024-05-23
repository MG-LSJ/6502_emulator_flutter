import 'package:emulator/runtime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatusFlagsRow extends ConsumerStatefulWidget {
  const StatusFlagsRow({super.key});

  @override
  ConsumerState<StatusFlagsRow> createState() => _StatusFlagsRowState();
}

class _StatusFlagsRowState extends ConsumerState<StatusFlagsRow> {
  @override
  Widget build(BuildContext context) {
    ref.watch(cpuClockNotifierProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        ..._buildFlag(
            flag: 'C',
            value: cpu.flags.c,
            onChanged: (val) {
              setState(() {
                cpu.flags.c = val ?? false;
              });
            }),
        const SizedBox(width: 10),
        ..._buildFlag(
            flag: 'Z',
            value: cpu.flags.z,
            onChanged: (val) {
              setState(() {
                cpu.flags.z = val ?? false;
              });
            }),
        const SizedBox(width: 10),
        ..._buildFlag(
            flag: 'I',
            value: cpu.flags.i,
            onChanged: (val) {
              setState(() {
                cpu.flags.i = val ?? false;
              });
            }),
        const SizedBox(width: 10),
        ..._buildFlag(
            flag: 'D',
            value: cpu.flags.d,
            onChanged: (val) {
              setState(() {
                cpu.flags.d = val ?? false;
              });
            }),
        const SizedBox(width: 10),
        ..._buildFlag(
            flag: 'B',
            value: cpu.flags.b,
            onChanged: (val) {
              setState(() {
                cpu.flags.b = val ?? false;
              });
            }),
        const SizedBox(width: 10),
        ..._buildFlag(
            flag: 'U',
            value: cpu.flags.u,
            onChanged: (val) {
              setState(() {
                cpu.flags.u = val ?? false;
              });
            }),
        const SizedBox(width: 10),
        ..._buildFlag(
            flag: 'V',
            value: cpu.flags.v,
            onChanged: (val) {
              setState(() {
                cpu.flags.v = val ?? false;
              });
            }),
        const SizedBox(width: 10),
        ..._buildFlag(
          flag: 'N',
          value: cpu.flags.n,
          onChanged: (val) {
            setState(() {
              cpu.flags.n = val ?? false;
            });
          },
        ),
      ],
    );
  }
}

List<Widget> _buildFlag(
    {required String flag,
    required bool value,
    required Function(bool?) onChanged}) {
  return [
    Text(flag),
    Checkbox(
      value: value,
      onChanged: onChanged,
    )
  ];
}
