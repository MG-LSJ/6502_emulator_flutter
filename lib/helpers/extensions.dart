extension IntExtensions on int {
  String printHex(
          {int precision = 4, String prefix = r'', String suffix = r''}) =>
      formatHex(this, precision: precision, prefix: prefix, suffix: suffix);
}

String formatHex(int value,
        {int precision = 4, String prefix = r'', String suffix = r''}) =>
    '$prefix${value.toRadixString(16).toUpperCase().padLeft(precision, '0')}$suffix';
