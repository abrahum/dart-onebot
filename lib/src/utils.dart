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
  String url() {
    return 'ws://${address.address}:$port${path ?? ''}';
  }

  WSSConfig.$default()
      : address = InternetAddress('127.0.0.1'),
        port = 8844;

  WSSConfig.fromMap(Map<String, dynamic> map)
      : address = InternetAddress(map.tryGet('address') as String),
        port = map.tryGet('port') as int,
        path = map['path'] as String?,
        accessToken = map['access_token'] as String?;

  Map<String, dynamic> toMap() => {
        'address': address.address,
        'port': port,
        if (path != null) 'path': path,
        if (accessToken != null) 'access_token': accessToken,
      };
}

class AppConfig {
  Set<WSSConfig> websocketRev = {};
  AppConfig();
  AppConfig.$default() {
    websocketRev.add(WSSConfig.$default());
  }

  AppConfig.fromMap(Map<String, dynamic> map) {
    for (final wss in map.tryGet('websocket_rev') as List<dynamic>) {
      websocketRev.add(WSSConfig.fromMap(wss as Map<String, dynamic>));
    }
  }

  Map<String, dynamic> toMap() => {
        'websocket_rev': [
          for (final wss in websocketRev) wss.toMap(),
        ],
      };
}
