import 'dart:convert';
import 'package:onebot/onebot.dart';

const standardEventBuilderMap = {
  MetaEvent.ty: {HeartbeatEvent.detailTy: HeartbeatEvent._fromJson}
};

class EventParser {
  late final Map<String, Map<String, Function(Map<String, dynamic>)>> map;
  EventParser(
      [Map<String, Map<String, Function(Map<String, dynamic>)>>? extra]) {
    if (extra != null) {
      map = Map.from(standardEventBuilderMap)..addAll(extra);
    } else {
      map = standardEventBuilderMap;
    }
  }

  Event fromJson(Map<String, dynamic> json) {
    final type = json.tryRemove('type') as String;
    final detailType = json.tryRemove('detail_type') as String;
    final fs = map[type];
    if (fs != null) {
      final f = fs[detailType];
      if (f != null) {
        return f(json);
      }
    }
    return Event._fromJson(json, type, detailType);
  }

  Event fromString(String json) {
    return fromJson(jsonDecode(json));
  }
}

class Event {
  String id, impl, plateform, selfId, type, detailType;
  String subType = '';
  double time;
  Map<String, dynamic> extra;
  Event(this.id, this.impl, this.plateform, this.type, this.selfId,
      this.detailType, this.subType, this.time,
      [Map<String, dynamic>? extra])
      : extra = extra ?? {};
  Map<String, dynamic> toJson() {
    return _toJson({});
  }

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> _toJson(Map<String, dynamic> data) {
    return extra
      ..addAll(data)
      ..addAll({
        'id': id,
        'impl': impl,
        'plateform': plateform,
        'self_id': selfId,
        'type': type,
        'detail_type': detailType,
        'sub_type': subType,
        'time': time
      });
  }

  Event._fromJson(Map<String, dynamic> data, this.type, this.detailType)
      : id = data.tryRemove('id') as String,
        impl = data.tryRemove('impl') as String,
        plateform = data.tryRemove('plateform') as String,
        selfId = data.tryRemove('self_id') as String,
        subType = data.tryRemove('sub_type') as String,
        time = data.tryRemove('time') as double,
        extra = data;
}

class MetaEvent extends Event {
  static const String ty = 'meta';
  MetaEvent(String id, String impl, String plateform, String selfId,
      String detailType, String subType, double time,
      [Map<String, dynamic>? extra])
      : super(
            id, impl, plateform, ty, selfId, detailType, subType, time, extra);
  MetaEvent._fromJson(Map<String, dynamic> data, String detailType)
      : super._fromJson(data, ty, detailType);
}

class HeartbeatEvent extends MetaEvent {
  static const String detailTy = 'heartbeat';
  int interval;
  HeartbeatEvent(String id, String impl, String plateform, String selfId,
      this.interval, num time, [Map<String, dynamic>? extra])
      : super(
            id, impl, plateform, selfId, detailTy, "", time.toDouble(), extra);
  HeartbeatEvent._fromJson(Map<String, dynamic> json)
      : interval = json.tryRemove('interval') as int,
        super._fromJson(json, detailTy);

  @override
  Map<String, dynamic> toJson() => _toJson({'interval': interval});
}
