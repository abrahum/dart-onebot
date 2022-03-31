import 'action.dart';
import 'message.dart';
import 'comms.dart';
import 'utils.dart';
import 'event.dart';

class OneBotImpl {
  String selfId;
  final String impl, platform;
  final ActionParser actionParser;
  List<Comm> comms = [];

  OneBotImpl(this.impl, this.platform, this.selfId,
      {ActionParser? actionParser, SegmentParser? segmentParser})
      : actionParser =
            actionParser ?? ActionParser(segmentParser ?? SegmentParser());

  int start({List<WSSConfig>? wssConfigs}) {
    for (final config in wssConfigs ?? []) {
      final wss = WSS(config);
      wss.implStart(this);
      comms.add(wss);
    }
    return comms.length;
  }

  void stop() {
    for (final comm in comms) {
      comm.close();
    }
    comms.clear();
  }

  Future<Response> handleAction(Action action) async {
    //todo
    return Response.unsupportedAction();
  }

  String newEventId() => '${DateTime.now().millisecondsSinceEpoch}'; //todo

  Event newEvent(String type, String detailType, String subType,
      [Map<String, dynamic>? extra]) {
    return Event(newEventId(), impl, platform, type, selfId, detailType,
        subType, DateTime.now().millisecondsSinceEpoch / 1000.0, extra);
  }

  MetaEvent newMetaEvent(String detailType, String subType,
      [Map<String, dynamic>? extra]) {
    return MetaEvent(newEventId(), impl, platform, selfId, detailType, subType,
        DateTime.now().millisecondsSinceEpoch / 1000.0, extra);
  }

  HeartbeatEvent newHeartbeatEvent(int interval,
      [Map<String, dynamic>? extra]) {
    return HeartbeatEvent(newEventId(), impl, platform, selfId, interval,
        DateTime.now().millisecondsSinceEpoch / 1000.0, extra);
  }
}
