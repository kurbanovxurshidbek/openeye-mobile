import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:key_board_app/services/hive_service.dart';

class Network {
  static bool isTester = true;

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }

  static String SERVER_DEVELOPMENT =
      "https://eastus.tts.speech.microsoft.com/cognitiveservices/v1";
  static String SERVER_PRODUCTION = "eastus.tts.speech.microsoft.com";

  ///for pdf to text
  // static String SERVER_PDF_TO_TEXT = "selectpdf.com";
  static String SERVER_PDF_TO_TEXT = "10.10.6.66:8023";

  ///for pdf to text
  static String SERVER_IMAGE_TO_TEXT = "10.10.6.66:8023";

  ///for pdf to text
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

  static Future<List<String>> getContent(String content) async {
    List<String> list = content.split(" ");
    list.retainWhere((item) => item.toString().isNotEmpty);
    String str = "";
    List<String> listofContent = [];
    for (int i = 0; i < list.length; i++) {
      str += list[i] + " ";
      if (i % 1000 == 0 && i != 0) {
        listofContent.add(str);
        return listofContent;
      }
    }
    listofContent.add(str);
    return listofContent;
  }

  static Future<Uint8List?> getAudioFromApi(String content) async {
    String? langCode = HiveDB.loadLangCode()!;
    String? voice = HiveDB.loadCountryCode(key: "voice")!;
    Uint8List? uint8List;

    switch (langCode) {
      case "uz":
        {
          uint8List = (await POST(getBody(
              langCode: lang_code_uz,
              speeker:
                  (voice == "famale") ? speeker_uz_famale : speeker_uz_male,
              content: content)));
          break;
        }
      case "en":
        {
          uint8List = (await POST(getBody(
              langCode: lang_code_en,
              speeker:
                  (voice == "famale") ? speeker_en_famale : speeker_en_male,
              content: content)));

          break;
        }
      case "ru":
        {
          uint8List = (await POST(getBody(
              langCode: lang_code_ru,
              speeker:
                  (voice == "famale") ? speeker_ru_famale : speeker_ru_male,
              content: content)));
          break;
        }
    }
    return uint8List;
  }


  // ///for pdt to text
  // static Future<String?> MULTIPART(String path) async {
  //   var uri = Uri.https(SERVER_PDF_TO_TEXT, API_PDF_STRING);
  //   var request = MultipartRequest("POST", uri);
  //
  //   request.headers.addAll(getHeaders());
  //   request.fields.addAll(getUploadHeaders());
  //   request.files.add(await MultipartFile.fromPath('url', path,
  //       contentType: MediaType("Application", "pdf")));
  //   request.fields.addAll(
  //     {
  //       "key": "0f7bdb34-3c52-4030-a1ed-16425e628f44",
  //     },
  //   );
  //   StreamedResponse response = await request.send();
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     print("+++++++++++++++++++");
  //     return await response.stream.bytesToString();
  //   } else {
  //     print("-------------------: ${response.statusCode}");
  //     return response.reasonPhrase;
  //   }
  // }

  static Future<String?> MULTIPART(String path) async {
    var uri = Uri.http(SERVER_PDF_TO_TEXT, API_PDF_STRING);
    var request = MultipartRequest("POST", uri);
    print("ssssssssssssssssssssssssssssss $request");

    // request.headers.addAll(getHeaders());
    // request.fields.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath('file', path,
        contentType: MediaType("Application", "pdf")));
    print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv $request");
    StreamedResponse response = await request.send();
    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa $response");

    print("StatusCode1: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      print("+++++++++++++++++++");
      return await response.stream.bytesToString();
    } else {
      print("-------------------: ${response.statusCode}");
      return response.reasonPhrase;
    }
  }


  static Future<String?> postImage(File filePath,String lang) async {
    var uri = Uri.http(SERVER_IMAGE_TO_TEXT, API_IMAGE_STRING);
    var request = MultipartRequest('POST', uri);
    print("ddddddddddddddddddddd $request");

    request.files.add(await MultipartFile.fromPath('Image', filePath.path,
        contentType: MediaType("image", "jpg")));
    request.fields.addAll({"DestinationLanguage" : lang, "Image" : filePath.path});
    StreamedResponse response = await request.send();
    print("aaaaaaaaaaaaaaaaaaaaa $response");

    print("StatusCode1: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return await response.stream.bytesToString();
    } else {
      return response.reasonPhrase;
    }
  }

  // static Future<String?> postImage(File file, String language) async {
  //   var url = Uri.https("api.ocr.space", "/parse/image");
  //   var request = MultipartRequest('POST', url);
  //   request.headers.addAll({"apikey" : "helloworld"});
  //   request.files.add(await MultipartFile.fromPath('file', file.path));
  //   request.fields.addAll({
  //     "language" : language,
  //   },);
  //   StreamedResponse response = await request.send();
  //   if (response.statusCode == 200 || response.statusCode == 201) {
  //     String res = jsonDecode(await response.stream.bytesToString())["ParsedResults"][0]["ParsedText"].toString();
  //     print("+++ : ${res}");
  //     return res;
  //   } else {
  //     return response.reasonPhrase;
  //   }
  // }


  static Future<String?> DEL(String api, Map<String, String> params) async {
    var uri = Uri.https(getServer(), api, params); // http or https
    var response = await delete(uri, headers: getHeaders());
    if (response.statusCode == 200) return response.body;

    return null;
  }

  /* Http Apis */

  // static String API_PDF_STRING = "/api2/pdftotext/";
  static String API_PDF_STRING = "/convert/pdf";

  static String API_IMAGE_STRING = "/convert/image";

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
}
