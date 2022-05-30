import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:key_board_app/services/hive_service.dart';

class Network {
  static bool isTester = true;

  static String SERVER_DEVELOPMENT =
      "https://eastus.tts.speech.microsoft.com/cognitiveservices/v1";
  static String SERVER_PRODUCTION = "eastus.tts.speech.microsoft.com";

  static String SERVER_PDF_TO_TEXT =
      "https://v2.convertapi.com/convert/pdf/to/txt?Secret=y9tE6pCjXnXMtyby&StoreFile=true";

  static Map<String, String> pdfHeaders() {
    Map<String, String> header = {"Content-Type": "application/json"};
    return header;
  }

  static Map<String, String> getHeaders() {
    Map<String, String> headers = {
      "X-Microsoft-OutputFormat": "audio-16khz-128kbitrate-mono-mp3",
      "Content-Type": "application/ssml+xml",
      "Ocp-Apim-Subscription-Key": "d2e4d2c1b35c420cb966994b329e55a6",
    };
    return headers;
  }

  static Map<String, String> getUploadHeaders() {
    Map<String, String> headers = {
      'Content-Type':
          'multipart/form-data; boundary=---011000010111000001101001'
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

  ///for pdt to text
  static Future<String?> MULTIPART(File file, Map<String, dynamic> body) async {
    var uri = Uri.https(getServer(), API_STRING);
    var request = MultipartRequest("POST", uri);

    request.headers.addAll(getHeaders());
    request.fields.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath('url', file.path,
        contentType: MediaType("Application", "pdf")));
    request.fields.addAll(
      {
        "key": "6ed9b5b2-d54a-4e2e-9b59-de7eda973110",
      },
    );
    StreamedResponse response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("+++++++++++++++++++");
      return await response.stream.bytesToString();
    } else {
      print("-------------------: ${response.statusCode}");
      return response.reasonPhrase;
    }
  }

  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    print(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  /* Http Apis */

  static String API_STRING = "/api2/pdftotext/";

  static String API_POST = "/cognitiveservices/v1";

  static String lang_code_uz = 'uz-UZ';
  static String lang_code_ru = 'ru-RU';
  static String lang_code_en = 'en-US';

  ///uz
  static String speeker_uz_male = 'uz-UZ-SardorNeural';
  static String speeker_uz_famale = 'uz-UZ-MadinaNeural';

  ///ru
  static String speeker_ru_famale = 'ru-RU-SvetlanaNeural';
  static String speeker_ru_male = 'ru-RU-DmitryNeural';

  ///en
  static String speeker_en_famale = 'en-US-SaraNeural';
  static String speeker_en_male = 'en-US-JacobNeural';

  static getBody(
      {required String langCode,
      required String speeker,
      required String content}) {
    String body =
        "<speak version='1.0' xml:lang='$langCode'><voice xml:lang='$langCode' xml:gender='Male' name='$speeker'> $content</voice></speak>";
    return body;
  }

  static Map<String, dynamic> bodyPdfToText(String userKey, File file) {
    Map<String, dynamic> params = {};
    params.addAll({
      "key": userKey,
      "uri": file,
    });
    return params;
  }

  static Future<String?> paramsLoad(File file) async {
    Map<String, dynamic> map = {};
    map.addAll({
      "key": "b2815f0c-11e8-4b22-af6d-1114958b2e23",
      "url": file,
    });
    String? result = await MULTIPART(file, map);
    return result;
  }
}
