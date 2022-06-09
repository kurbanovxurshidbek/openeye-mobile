import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:key_board_app/logic/check_latin.dart';
import 'package:key_board_app/logic/kril_to_latin.dart';
import 'package:key_board_app/logic/numbers_to_text.dart';
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
  static String SERVER_PDF_TO_TEXT =
      "selectpdf.com";

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

  static Future  <List<String>> getContent(String content)async{
    List <String> list = content.split(" ");
    list.retainWhere((item) => item.toString().isNotEmpty);
    String str = "";
    List <String> listofContent = [];
    for (int i = 0; i < list.length; i++) {
      str += list[i] + " ";
      if (i % 1000 == 0 && i != 0) {
        str = await toLatin(str);
        listofContent.add(str);
        return listofContent;
      }
    }
    listofContent.add(str);
    return listofContent;
  }

  static Future<Uint8List> getAudioFromApi(List listOfContent) async {
    String? langCode = HiveDB.loadLangCode()!;
    String? voice = HiveDB.loadCountryCode(key: "voice")!;
    List <List<int>> uint8lists = [];
    Uint8List? uint8List;

    switch (langCode) {
      case "uz":
        {
          for (int i = 0; i < listOfContent.length; i++) {
            listOfContent[i] = await checkLatin(listOfContent[i]);
            listOfContent[i]= textEditing(listOfContent[i]);
              print("ListOfCount: $listOfContent");
              uint8List = (await POST(getBody(
                  langCode: lang_code_uz,
                  speeker:
                  (voice == "famale") ? speeker_uz_famale : speeker_uz_male,
                  content: listOfContent[i])));

              if(uint8List!=null){
                uint8lists.add(uint8List.toList());
              }
            }
          uint8List = Uint8List.fromList(uint8lists.expand((element) => element).toList());
          print(uint8List);
          return uint8List;
        }
      case "en":
        {
          for (int i = 0; i < listOfContent.length; i++) {
            uint8List = (await POST(getBody(
                langCode: lang_code_uz,
                speeker:
                (voice == "famale") ? speeker_en_famale : speeker_en_male,
                content: listOfContent[i])));

            if(uint8List!=null){
              uint8lists.add(uint8List.toList());
            }
          }
          uint8List = Uint8List.fromList(uint8lists.expand((element) => element).toList());
          print(uint8List);
          return uint8List;
        }
      case "ru":
        {
          for (int i = 0; i < listOfContent.length; i++) {
            uint8List = (await POST(getBody(
                langCode: lang_code_ru,
                speeker:
                (voice == "famale") ? speeker_ru_famale : speeker_ru_male,
                content: listOfContent[i]))) ;
            if(uint8List!=null){
              uint8lists.add(uint8List.toList());
            }
          }
          uint8List = Uint8List.fromList(uint8lists.expand((element) => element).toList());
          return uint8List;
        }
    }
    return uint8List!;
  }

  // static Future<Uint8List?> getAudioFromApi(String content) async {
  //   String? langCode = HiveDB.loadLangCode()!;
  //   String? voice = HiveDB.loadCountryCode(key: "voice")!;
  //   Uint8List? uint8list;
  //
  //   print(langCode + "--------------------");
  //   print(voice.toString() + "+++++++++++++++++++++++");
  //   print(content);
  //   switch (langCode) {
  //     case "uz":
  //       {
  //         uint8list = await POST(getBody(
  //             langCode: lang_code_uz,
  //             speeker:
  //             (voice == "famale") ? speeker_uz_famale : speeker_uz_male,
  //             content: content));
  //       }
  //       break;
  //     case "en":
  //       {
  //         uint8list = await POST(getBody(
  //             langCode: lang_code_en,
  //             speeker:
  //             (voice == "famale") ? speeker_en_famale : speeker_en_male,
  //             content: content));
  //       }
  //       break;
  //     case "ru":
  //       {
  //         uint8list = await POST(getBody(
  //             langCode: lang_code_ru,
  //             speeker:
  //             (voice == "famale") ? speeker_ru_famale : speeker_ru_male,
  //             content: content));
  //       }
  //       break;
  //   }
  //
  //   return uint8list;
  // }

  ///for pdt to text
  static Future<String?> MULTIPART(String path) async {
    var uri = Uri.https(SERVER_PDF_TO_TEXT, API_STRING);
    var request = MultipartRequest("POST", uri);

    request.headers.addAll(getHeaders());
    request.fields.addAll(getUploadHeaders());
    request.files.add(await MultipartFile.fromPath('url', path,
        contentType: MediaType("Application", "pdf")));
    request.fields.addAll(
      {
        "key": "694b735b-52dc-4260-9329-e469a362fd8c",
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
}