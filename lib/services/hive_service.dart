import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDB {
  static String DB_NAME = 'openeye';
  static Box box = Hive.box(DB_NAME);

  static Future<void> storeLang(String langCode, String countryCode) async {
    await box.put("langCode", langCode);
    await box.put("countryCode", countryCode);
  }

  static Future<void> saveData(String key, String value) async {
    await box.put(key, value);
  }

  static String? loadLangCode() {
    var langCode = box.get("langCode");
    return langCode;
  }

  static String loadCountryCode({String? key}) {
    if (key != null) {
      return box.get(key);
    }
    var countryCode = box.get("countryCode");
    return countryCode;
  }

  static void removeLang() async {
    box.delete('langCode');
  }
}
