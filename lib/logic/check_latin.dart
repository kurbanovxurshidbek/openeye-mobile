import 'package:key_board_app/logic/kril_to_latin.dart';
import 'package:key_board_app/services/hive_service.dart';

Future<String> checkLatin(String? text) async {
  String? countryCode = HiveDB.loadLangCode();

  if (text != null && countryCode != null && countryCode == "uz") {
    if (text.contains("в") ||
        text.contains("б") ||
        text.contains("я") ||
        text.contains("ю") ||
        text.contains("ь") ||
        text.contains("ж") ||
        text.contains("э")) {
      text = await toLatin(text);
    }
  }

  return text!;
}
