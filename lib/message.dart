import 'dart:convert';
import 'package:onebot/onebot.dart';

const standardSegmentParserMap = {
  TextSegment.ty: TextSegment.fromData,
  MentionSegment.ty: MentionSegment.fromData,
  MentionAllSegment.ty: MentionAllSegment.fromData,
  ImageSegment.ty: ImageSegment.fromData,
  VoiceSegment.ty: VoiceSegment.fromData,
  AudioSegment.ty: AudioSegment.fromData,
  VideoSegment.ty: VideoSegment.fromData,
  FileSegment.ty: FileSegment.fromData,
  LocationSegment.ty: LocationSegment.fromData,
  ReplySegment.ty: ReplySegment.fromData,
};

class SegmentParser {
  late final Map<String, Segment Function(Map<String, dynamic>)> map;
  SegmentParser([Map<String, Segment Function(Map<String, dynamic>)>? extra]) {
    if (extra != null) {
      map = Map.from(standardSegmentParserMap)..addAll(extra);
    } else {
      map = standardSegmentParserMap;
    }
  }

  Segment fromJson(Map<String, dynamic> json) {
    final type = json.tryRemove('type') as String;
    final data = json.tryRemove('data');
    final f = map[type];
    if (f != null) {
      return f(data);
    }
    return Segment(type, data);
  }

  List<Segment> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map((e) => fromJson(e)).toList();
  }
}

class Segment {
  String type;
  Map<String, dynamic> extra;
  Segment(this.type, [Map<String, dynamic>? extra]) : extra = extra ?? {};
  Map<String, dynamic> data() => extra;
  Map<String, dynamic> toJson() => {
        'type': type,
        'data': data(),
      };
  @override
  String toString() => jsonEncode(toJson());
}

class TextSegment extends Segment {
  static const String ty = 'text';
  String text;
  TextSegment(this.text, [Map<String, dynamic>? extra]) : super(ty, extra);
  TextSegment.fromData(Map<String, dynamic> data)
      : text = data.tryRemove('text') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra..addAll({ty: text});
}

class MentionSegment extends Segment {
  static const String ty = 'mention';
  String userId;
  MentionSegment(this.userId, [Map<String, dynamic>? extra]) : super(ty, extra);
  MentionSegment.fromData(Map<String, dynamic> data)
      : userId = data.tryRemove('uesr_id') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra..addAll({'user_id': userId});
}

class MentionAllSegment extends Segment {
  static const String ty = "mention_all";
  MentionAllSegment([Map<String, dynamic>? extra]) : super(ty, extra);
  MentionAllSegment.fromData(Map<String, dynamic> data) : super(ty, data);
}

class ImageSegment extends Segment {
  static const String ty = "image";
  String fileId;
  ImageSegment(this.fileId, [Map<String, dynamic>? extra]) : super(ty, extra);
  ImageSegment.fromData(Map<String, dynamic> data)
      : fileId = data.tryRemove('file_id') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra..addAll({'file_id': fileId});
}

class VoiceSegment extends Segment {
  static const String ty = "voice";
  String fileId;
  VoiceSegment(this.fileId, [Map<String, dynamic>? extra]) : super(ty, extra);
  VoiceSegment.fromData(Map<String, dynamic> data)
      : fileId = data.tryRemove('file_id') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra..addAll({'file_id': fileId});
}

class AudioSegment extends Segment {
  static const String ty = "audio";
  String fileId;
  AudioSegment(this.fileId, [Map<String, dynamic>? extra]) : super(ty, extra);
  AudioSegment.fromData(Map<String, dynamic> data)
      : fileId = data.tryRemove('file_id') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra..addAll({'file_id': fileId});
}

class VideoSegment extends Segment {
  static const String ty = "video";
  String fileId;
  VideoSegment(this.fileId, [Map<String, dynamic>? extra]) : super(ty, extra);
  VideoSegment.fromData(Map<String, dynamic> data)
      : fileId = data.tryRemove('file_id') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra..addAll({'file_id': fileId});
}

class FileSegment extends Segment {
  static const String ty = "file";
  String fileId;
  FileSegment(this.fileId, [Map<String, dynamic>? extra]) : super(ty, extra);
  FileSegment.fromData(Map<String, dynamic> data)
      : fileId = data.tryRemove('file_id') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra..addAll({'file_id': fileId});
}

class LocationSegment extends Segment {
  static const String ty = 'location';
  double latitude;
  double longitude;
  String title;
  String content;
  LocationSegment(this.latitude, this.longitude, this.title, this.content,
      [Map<String, dynamic>? extra])
      : super(ty, extra);
  LocationSegment.fromData(Map<String, dynamic> data)
      : latitude = data.tryRemove('latitude') as double,
        longitude = data.tryRemove('longitude') as double,
        title = data.tryRemove('title') as String,
        content = data.tryRemove('content') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() => extra
    ..addAll({
      'latitude': latitude,
      'longitude': longitude,
      'title': title,
      'content': content
    });
}

class ReplySegment extends Segment {
  static const String ty = 'reply';
  String messageId;
  String userId;
  ReplySegment(this.messageId, this.userId, [Map<String, dynamic>? extra])
      : super(ty, extra);
  ReplySegment.fromData(Map<String, dynamic> data)
      : messageId = data.tryRemove('message_id') as String,
        userId = data.tryRemove('user_id') as String,
        super(ty, data);

  @override
  Map<String, dynamic> data() =>
      extra..addAll({'message_id': messageId, 'user_id': userId});
}
