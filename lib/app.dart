import 'dart:isolate';

import 'package:onebot/onebot.dart';
import 'dart:io';

class OneBotApp {
  List<Comm> comms = [];
  void Function(Bot, Event)? eventHandler;
  void Function(Bot, Event, dynamic)? eventHandlerOnError;
  final EventParser eventParser;
  OneBotApp({EventParser? eventParser, SegmentParser? segmentParser})
      : eventParser =
            eventParser ?? EventParser(segmentParser ?? SegmentParser());
  void handleEvent(Bot bot, Event event) async {
    if (eventHandler != null) {
      try {
        eventHandler!(bot, event);
      } catch (e) {
        if (eventHandlerOnError != null) {
          eventHandlerOnError!(bot, event, e);
        }
      }
    }
  }

  int start({List<WSSConfig>? wssConfigs}) {
    for (final config in wssConfigs ?? []) {
      final wss = WSS(config);
      logger.info('start websocket server on ${config.url()}');
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

  void onEvent(void Function(Bot, Event) handler,
      {void Function(Bot, Event, dynamic)? onError}) {
    eventHandler = handler;
    eventHandlerOnError = onError;
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
