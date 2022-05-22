import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter/material.dart';

import '../logic/kril_to_latin.dart';

class FilePickerService {
  static Future<List<String>?> getTextFromPdfAndName(
      BuildContext context) async {
    //Load an existing PDF document.
    List<String>? list = await readDocumentData();
    print(list);

    if (list != null) {
      String text = await getPDFtext(list[0]);
      if (text.contains("в") ||
          text.contains("б") ||
          text.contains("я") ||
          text.contains("ю") ||
          text.contains("ь") ||
          text.contains("ж") ||
          text.contains("э")) {
        text = await toLatin(text);
      }
      return [text, list[1]];
    }

//

    return null;
  }

  static Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    return text;
  }

  static showD(BuildContext context, String str) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text(str),
          ),
        );
      },
    );
  }

  static Future<List<String>?> readDocumentData() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.first.path!);

      return [file.path, result.files.first.name];
    } else {
      return null;
    }
  }
}
