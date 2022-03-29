import 'package:onebot/app.dart';
import 'package:onebot/onebot.dart';

import 'dart:io';

void main() {
  final ob = OneBotApp((bot, event) => print(event));
  ob.start(wssConfigs: [WSSConfig(InternetAddress("127.0.0.1"), 18886)]);
  print('done');
  ProcessSignal.sigint.watch().listen((_) {
    ob.stop();
    exit(0);
  });
}
