import 'package:onebot/app.dart';
import 'package:onebot/onebot.dart';
import 'package:logging/logging.dart';

import 'dart:io';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord record) =>
      print('[${record.level.name}] ${record.time} ${record.message}'));
  final ob = OneBotApp();
  ob.start(wssConfigs: [WSSConfig(InternetAddress("127.0.0.1"), 18886)]);
  ob.onEvent((Bot _, Event e) {
    print(e);
  });
  ProcessSignal.sigint.watch().listen((_) {
    ob.stop();
    exit(0);
  });
}
