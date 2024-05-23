import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'runtime.dart';

void handleKeyboardEvent(KeyEvent event, WidgetRef ref) {
  if (event is KeyDownEvent) {
    switch (event.logicalKey) {
      case LogicalKeyboardKey.space:
        {
          do {
            cpu.clock();
          } while (!cpu.complete());
          print(cpu.complete());
          ref.read(cpuClockNotifierProvider).update();
        }
        break;
    }
  }
}
