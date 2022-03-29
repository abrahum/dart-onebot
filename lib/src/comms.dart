import 'dart:io';
import 'package:onebot/onebot.dart';
part 'comms.ws.dart';

abstract class Comms {
  void send(String msg);
  void sendEvent(Event event) => send(event.toString());
  void sendAction(Action action) => send(action.toString());
}
