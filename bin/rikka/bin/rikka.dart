import 'package:rikka/rikka.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import 'package:onebot/onebot.dart' hide logger;

void main(List<String> arguments) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord record) => print(
      '[${record.loggerName}:${record.level.name}] ${record.time} ${record.message}'));
  var config = await loadOrNewConfig();
  final ob = OneBotApp();

  ob.onEvent((Bot bot, Event event) {
    if (event is MessageEvent) {
      if (event.altMessage == 'rikka') {
        bot.sendMessage([TextSegment('hihi')], userId: event.userId);
      } else if (event.altMessage == 'onebot') {
        bot.sendMessage([
          ImageSegment('onebot',
              {'url': 'https://12.onebot.dev/assets/images/logo-white.png'})
        ], userId: event.userId);
      }
    }
  });

  ob.start(config);
  ProcessSignal.sigint.watch().listen((_) {
    ob.stop();
    exit(0);
  });
}
