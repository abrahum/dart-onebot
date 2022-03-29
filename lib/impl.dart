import 'package:onebot/onebot.dart';

class OneBotImpl {
  String selfId;
  final String impl, plateform;
  final EventParser eventParser;
  final ActionParser actionParser;
  final SegmentParser segmentParser;

  OneBotImpl(this.impl, this.plateform, this.selfId,
      {EventParser? eventParser,
      ActionParser? actionParser,
      SegmentParser? segmentParser})
      : eventParser = eventParser ?? EventParser(),
        actionParser = actionParser ?? ActionParser(),
        segmentParser = segmentParser ?? SegmentParser();

  Response handleAction(Action action) {
    //todo
    return Response.unsupportedAction();
  }

  String newEventId() => '${DateTime.now().millisecondsSinceEpoch}'; //todo

  Event newEvent(String type, String detailType, String subType,
      [Map<String, dynamic>? extra]) {
    return Event(newEventId(), impl, plateform, type, selfId, detailType,
        subType, DateTime.now().millisecondsSinceEpoch / 1000.0, extra);
  }

  MetaEvent newMetaEvent(String detailType, String subType,
      [Map<String, dynamic>? extra]) {
    return MetaEvent(newEventId(), impl, plateform, selfId, detailType, subType,
        DateTime.now().millisecondsSinceEpoch / 1000.0, extra);
  }

  HeartbeatEvent newHeartbeatEvent(int interval,
      [Map<String, dynamic>? extra]) {
    return HeartbeatEvent(newEventId(), impl, plateform, selfId, interval,
        DateTime.now().millisecondsSinceEpoch / 1000.0, extra);
  }
}
