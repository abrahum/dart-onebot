import 'matcher.dart';
import 'onebot.dart';

class Plugin {
  String name;
  Plugin(this.name);

  Set<void Function()> $onStartupSet = {};
  void onStart(void Function() f) {
    $onStartupSet.add(f);
  }

  void $Startup() {
    for (final f in $onStartupSet) {
      f();
    }
  }

  Set<void Function()> $onShutdownSet = {};
  void onShutdown(void Function() f) {
    $onShutdownSet.add(f);
  }

  void $Shutdown() {
    for (final f in $onShutdownSet) {
      f();
    }
  }

  Set<Matcher> $matchersSet = {};
  void add(Matcher matcher) {
    $matchersSet.add(matcher);
  }

  void call(Bot bot, Event event) {
    for (final matcher in $matchersSet) {
      matcher(bot, event);
    }
  }
}
