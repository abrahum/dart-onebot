import 'dart:io';

import 'package:toml/toml.dart';
import 'package:onebot/onebot.dart';

const String configPath = 'Rikka.toml';

Future<AppConfig> loadConfig() async {
  final file = File(configPath);
  final toml = TomlDocument.parse(await file.readAsString()).toMap();
  var config = AppConfig.fromMap(toml);
  return config;
}

Future<void> saveConfig(AppConfig config) async {
  final file = File(configPath);
  final toml = TomlDocument.fromMap(config.toMap());
  await file.writeAsString(toml.toString());
}

Future<AppConfig> loadOrNewConfig() async {
  try {
    return await loadConfig();
  } catch (e) {
    final config = AppConfig.$default();
    await saveConfig(config);
    return config;
  }
}
