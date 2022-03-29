import 'dart:io';

import 'package:onebot/onebot.dart';

void main() {
  final ob = OneBotImpl("impl", "plateform", "selfId");
  ob.start(wssConfigs: [WSSConfig(InternetAddress("127.0.0.1"), 8843)]);
  print('done');
  ProcessSignal.sigint.watch().listen((_) {
    ob.stop();
    exit(0);
  });
}
