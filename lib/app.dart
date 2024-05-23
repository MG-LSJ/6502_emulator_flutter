import 'package:emulator/home.dart';
import 'package:emulator/keyboard_listner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

const int offset = 0x8000;

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      onKeyEvent: (event) => handleKeyboardEvent(event, ref),
      focusNode: FocusNode(),
      child: MaterialApp(
        home: const HomeScreen(),
        title: "6502 Processor Emulator",
        theme: ThemeData(
          useMaterial3: true,
          textTheme:
              GoogleFonts.robotoMonoTextTheme(Theme.of(context).textTheme),
        ),
      ),
    );
  }
}
