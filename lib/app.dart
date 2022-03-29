import 'dart:isolate';

import 'package:onebot/onebot.dart';
import 'dart:io';

class OneBotApp {
  List<Comm> comms = [];
  void Function(Bot, Event) eventHandler;
  final EventParser eventParser;
  OneBotApp(this.eventHandler,
      {EventParser? eventParser, SegmentParser? segmentParser})
      : eventParser =
            eventParser ?? EventParser(segmentParser ?? SegmentParser());
  void handleEvent(Bot bot, Event event) async {
    eventHandler(bot, event);
  }

  int start({List<WSSConfig>? wssConfigs}) {
    for (final config in wssConfigs ?? []) {
      final wss = WSS(config);
      wss.appStart(this);
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
}

class Bot {
  WebSocket socket;
  Map<String, SendPort> waittingMap = {};
  Bot(this.socket);
  Future<Response> callAction(Action action, {int timeout = 10}) async {
    var echo = action.echo;
    final rx = ReceivePort();
    if (echo != null) {
      waittingMap.addAll({echo: rx.sendPort});
    }
    socket.add(action.toString());
    return await rx.first.timeout(
      Duration(seconds: timeout),
      onTimeout: () {
        waittingMap.remove(echo);
        throw CallActionTimeout(action);
      },
    );
  }

  Future<Response> getLatestResponse({int limit = 10, int timeout = 10}) async {
    return await callAction(GetLatestEventsAction(limit, timeout));
  }

  void handleResponse(Response resp) async {
    if (resp.echo != null) {
      final rx = waittingMap.remove(resp.echo);
      rx?.send(resp);
    }
  }
}
