import 'package:logging/logging.dart';
import 'package:rikka/config.dart';
import 'package:rikka/log.dart';
import 'package:rikka/plugin.dart';
import 'onebot.dart';

export 'config.dart';
export 'plugin.dart';
export 'matcher.dart';

final logger = Logger('Rikka');

Rikka? $rikka;

Future<Rikka> newRikka() async {
  final config = await loadOrNewConfig();
  logInit(Level.ALL);
  $rikka = Rikka(config);
  return $rikka!;
}

class Rikka {
  AppConfig config;
  List<Plugin> plugins = [];
  OneBotApp app;
  Rikka(this.config)
      : app = OneBotApp(eventParser: EventParser(SegmentParser()));

  void handleEvent(Bot bot, Event event) {
    logger.info('event: $event');
    for (final plugin in plugins) {
      plugin(bot, event);
    }
  }

  void run() async {
    logger.info('starting rikka');
    for (final plugin in plugins) {
      plugin.$Startup();
    }
    app.onEvent(handleEvent);
    app.start(config);
    //todo
  }

  void shutdown() async {
    for (final plugin in plugins) {
      plugin.$Shutdown();
    }
    app.stop();
    //todo
  }
}
