part of 'comms.dart';

class WSS extends Comms {
  final OneBotImpl ob;
  String? accessToken;
  List<WebSocket> sockets;
  WSS(this.ob, {this.accessToken}) : sockets = [];

  @override
  void send(String msg) {
    for (final socket in sockets) {
      socket.add(msg);
    }
  }

  void serve(InternetAddress address, int port,
      void Function(OneBotImpl, String) handler,
      {String? url}) async {
    final server = await HttpServer.bind(address, port);
    await server.forEach((HttpRequest req) async {
      if (url != null) {
        if (req.uri.path != url) {
          await req.response.close();
        }
      }
      if (accessToken != null) {
        if (req.headers.value('access_token') != accessToken) {
          await req.response.close();
        }
      }
      final socket = await WebSocketTransformer.upgrade(req);
      socket.listen(
        (event) => handler(ob, event),
        onDone: () => sockets.remove(socket),
        onError: () => sockets.remove(socket),
      );
      sockets.add(socket);
    });
  }
}

void implHandle(OneBotImpl ob, String msg) {
  try {
    var action = ob.actionParser.fromString(msg);
  } catch (e) {
    print(e); //todo log
  }
}
