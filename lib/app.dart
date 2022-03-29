import 'dart:isolate';

import 'package:onebot/onebot.dart';
import 'dart:io';

class OneBotApp {
  List<Comm> comms = [];
  final EventParser eventParser;
  OneBotApp({EventParser? eventParser})
      : eventParser = eventParser ?? EventParser();
  Future<void> handleEvent(Event event) async {
    print(event);
    //todo
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
  Future<Response> callAction(Action action) async {
    var echo = action.echo;
    final rx = ReceivePort();
    if (echo != null) {
      waittingMap.addAll({echo: rx.sendPort});
    }
    socket.add(action.toString());
    return await rx.first;
  }

  void handleResponse(Response resp) async {
    if (resp.echo != null) {
      final rx = waittingMap.remove(resp.echo);
      rx?.send(resp);
    }
  }
}
