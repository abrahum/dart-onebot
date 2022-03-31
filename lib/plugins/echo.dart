import 'package:rikka/plugin.dart';
import 'package:rikka/matcher.dart';
import 'package:rikka/onebot.dart';

Plugin echo() {
  var echo = Plugin('echo');
  echo.add(FnMatcher((Bot bot, Event event) {
    if (event is MessageEvent) {
      if (event.altMessage.startsWith('echo ')) {
        final msg = [TextSegment(event.altMessage.replaceFirst('echo ', ''))];
        if (event is GroupMessageEvent) {
          bot.sendGroupMessage(msg, event.groupId);
        } else if (event is PrivateMessageEvent) {
          bot.sendPrivateMessage(msg, event.userId);
        }
      }
    }
  }));
  return echo;
}
