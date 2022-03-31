import 'dart:convert';

import 'package:rikka/onebot.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    var ob = OneBotImpl("impl", "plateform", "selfId");
    var heartbeat = ob.newHeartbeatEvent(4);
    var json = jsonEncode(heartbeat.toJson());

    print(json);
  });
  test('message', () {
    final parser = SegmentParser();
    var textMessage = '{"type":"text","data":{"text":"hello"}}';
    var json = jsonDecode(textMessage);
    var segment = parser.fromJson(json);
    print(segment);

    var mentionMessage = '{"type":"mention","data":{"user_id":"id"}}';
    json = jsonDecode(mentionMessage);
    segment = parser.fromJson(json);
    print(segment);
  });
}
