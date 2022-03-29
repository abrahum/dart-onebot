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
