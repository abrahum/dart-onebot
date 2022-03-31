import 'dart:io';

import 'package:rikka/rikka.dart';
import 'package:rikka/plugins/echo.dart';

void main() async {
  final rikka = await newRikka();
  rikka.plugins.add(echo());
  rikka.run();
  ProcessSignal.sigint.watch().listen((_) {
    rikka.shutdown();
    exit(0);
  });
}
