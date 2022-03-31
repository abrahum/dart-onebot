import 'package:rikka/onebot.dart';

abstract class Matcher {
  //todo
  void call(Bot bot, Event event);
}

class FnMatcher extends Matcher {
  final void Function(Bot, Event) fn;
  FnMatcher(this.fn);
  @override
  void call(Bot bot, Event event) {
    fn(bot, event);
  }
}
