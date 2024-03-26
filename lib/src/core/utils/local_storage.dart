import 'package:hive/hive.dart';

class PrefManager {
  static final _storage = Hive.box("LOCAL_STORAGE");

  // static Future write(String key, String value) async {
  //   await _storage.put(key, value);
  // }
   static Future write(String key, dynamic value) async {
    await _storage.put(key, value);
  }

  static  read( key) {
    return _storage.get(key) ?? '';
  }

  static String readLocation(String key) {
    return _storage.get(key) ?? [];
  }

  static bool readBoolean(String key) {
    return (_storage.get(key)).toString().toLowerCase() == 'true';
  }

  static Future remove(String key) async {
    await _storage.delete(key);
  }

  static Future writebool(String key, bool value) async {
    await _storage.put(key, value.toString());
  }

  static Future clearAll() async {
    return await _storage.clear();
  }

  static Map<String, String> getHeader() {
    return {"authorization": "Bearer "};
  }
}
