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

  int start(AppConfig config) {
    for (final wssConfig in config.websocketRev) {
      final wss = WSS(wssConfig);
      logger.info('start websocket server on ${wssConfig.url()}');
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
    logger.info('calling action: $action');
    var echo = DateTime.now().millisecondsSinceEpoch.toString();
    action.echo = echo;
    final rx = ReceivePort();
    waittingMap.addAll({echo: rx.sendPort});
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
    return await callAction(GetLatestEvents(limit, timeout));
  }

  Future<Response> sendMessage(List<Segment> message,
      {String? userId, String? groupId}) async {
    return await callAction(SendMessage(
        (userId != null) ? 'private' : 'group', message,
        userId: userId, groupId: groupId));
  }

  Future<Response> sendPrivateMessage(
    List<Segment> message,
    String userId,
  ) async {
    return await sendMessage(message, userId: userId);
  }

  Future<Response> sendGroupMessage(
    List<Segment> message,
    String groupId,
  ) async {
    return await sendMessage(message, groupId: groupId);
  }

  void handleResponse(Response resp) async {
    if (resp.echo != null) {
      final rx = waittingMap.remove(resp.echo);
      rx?.send(resp);
    }
  }
}
