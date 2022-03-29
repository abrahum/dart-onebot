import 'dart:io';

import 'package:onebot/onebot.dart';

extension MapTryExt<K, V> on Map<K, V> {
  V tryGet(K key) {
    if (containsKey(key)) {
      return this[key]!;
    }
    throw MissFieldError(key.toString());
  }

  V tryRemove(K key) {
    if (containsKey(key)) {
      return remove(key)!;
    }
    throw MissFieldError(key.toString());
  }
}

class WSSConfig {
  InternetAddress address;
  int port;
  String? path;
  String? accessToken;
  WSSConfig(this.address, this.port, {this.path, String? accessToken}) {
    if (accessToken != null) {
      this.accessToken = 'token $accessToken';
    }
  }
}
