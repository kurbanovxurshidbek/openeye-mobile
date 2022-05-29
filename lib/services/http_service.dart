import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:key_board_app/services/hive_service.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT =
      "https://eastus.tts.speech.microsoft.com/cognitiveservices/v1";
  static String SERVER_PRODUCTION = "eastus.tts.speech.microsoft.com";

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      "X-Microsoft-OutputFormat": "audio-16khz-128kbitrate-mono-mp3",
      "Content-Type": "application/ssml+xml",
      "Ocp-Apim-Subscription-Key": "4bbf84b7e45d49e9a6b1af4d43efd368",
    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  /* Http Requests */

  static Future<String?> GET(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await get(uri, headers: getHeaders());
    //Log.d(response.body);

    if (response.statusCode == 200) return response.body;

    return null;
  }

  static Future<Uint8List?> POST(String body) async {
    var uri = Uri.parse(SERVER_DEVELOPMENT); // http or https
    var response = await post(uri, headers: getHeaders(), body: body);
    print("Statuscode: ${response.statusCode}");
    print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.bodyBytes;
    } else {
      return null;
    }
  }

  static Future<Uint8List?> getAudioFromApi(String content) async {
    String? langCode = HiveDB.loadLangCode()!;
    String? voice = HiveDB.loadCountryCode(key: "voice")!;
    Uint8List? uint8list;

    print(langCode + "--------------------");
    print(voice.toString() + "+++++++++++++++++++++++");
    print(content);

    switch (langCode) {
      case "uz":
        {
          uint8list = await POST(getBody(
              langCode: lang_code_uz,
              speeker:
                  (voice == "famale") ? speeker_uz_famale : speeker_uz_male,
              content: content));
        }
        break;
      case "en":
        {
          uint8list = await POST(getBody(
              langCode: lang_code_en,
              speeker:
                  (voice == "famale") ? speeker_en_famale : speeker_en_male,
              content: content));
        }
        break;
      case "ru":
        {
          uint8list = await POST(getBody(
              langCode: lang_code_ru,
              speeker:
                  (voice == "famale") ? speeker_ru_famale : speeker_ru_male,
              content: content));
        }
        break;
    }

    return uint8list;
  }

  Future<String?> MULTIPART(
      String api, String filePath, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api);
    var request = MultipartRequest("POST", uri);

    request.headers.addAll(getHeaders());
    request.fields.addAll(params);
    request.files.add(await MultipartFile.fromPath('picture', filePath));

    var res = await request.send();
    return res.reasonPhrase;
  }

  ///file bilan ishlash uchun serverga fayl yuklash uchun ishlatiladi

  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    print(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  /* Http Apis */
  static String API_POST = "/cognitiveservices/v1";

  static String lang_code_uz = 'uz-UZ';
  static String lang_code_ru = 'ru-RU';
  static String lang_code_en = 'en-US';

  ///uz
  static String speeker_uz_male = 'uz-UZ-SardorNeural';
  static String speeker_uz_famale = 'uz-UZ-MadinaNeural';

  ///ru
  static String speeker_ru_famale = 'ru-RU-SvetlanaNeural';
  static String speeker_ru_male = 'uz-UZ-DmitryNeural';

  ///en
  static String speeker_en_famale = 'en-US-SaraNeural';
  static String speeker_en_male = 'en-US-JacobNeural';

  static getBody(
      {required String langCode,
      required String speeker,
      required String content}) {
    String body =
        "<speak version='1.0' xml:lang='$langCode'><voice xml:lang='$langCode' xml:gender='Famale' name='$speeker'> $content</voice></speak>";
    return body;
  }
}
