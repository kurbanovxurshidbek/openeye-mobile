
/// textni wu funksiyaga tashang
String textEditing(String text) {
  RegExp regex = RegExp("[0-9]+");
  RegExp regex2 = RegExp("[0-9]+([ ]{0,}[-])([ ]{0,})[a-z]");
  RegExp regex3 = RegExp("[0-9][ ]{0,}([.])[ ]{0,}[0-9]");
  // kasr sonlarni to'g'irlash
  while(text.contains(regex3)) {
    text = text.replaceFirst(regex3.firstMatch(text)!.group(1)!, " nuqta ");
  }
  // butun sonlarni to'g'irlash
  while(text.contains(regex)) {
    if(text.contains(regex2)) {
      text = text.replaceFirst(regex2.firstMatch(text)!.group(1)!, " inchi ");
    }
    text = text.replaceFirst(regex, numToText(regex.stringMatch(text)!));
  }
  return text;
}

String numToText(String text) {
  String result = "";
  Map<String,Map<String,String>> mapp = {
    "0" : {
      "0":"",
      "1":"bir",
      "2":"ikki",
      "3":"uch",
      "4":"turt",
      "5":"besh",
      "6":"olti",
      "7":"yetti",
      "8":"sakkiz",
      "9":"tuqqiz",
    },
    "1" : {
      "0":"",
      "1":"un",
      "2":"yigirma",
      "3":"uttiz",
      "4":"qirq",
      "5":"ellik",
      "6":"oltmish",
      "7":"yetmish",
      "8":"sakson",
      "9":"tuqson",
    },
    "2" : {
      "0":"",
      "1":"bir yuz",
      "2":"ikki yuz",
      "3":"uch yuz",
      "4":"turt yuz",
      "5":"besh yuz",
      "6":"olti yuz",
      "7":"yetti yuz",
      "8":"sakkiz yuz",
      "9":"tuqqiz yuz",
    },
  };
  Map<int,String> darajalar = {
    3 : " ming",
    6 : " million",
    9 : " milliard",
    12 : " trillion",
    15 : " quadrillion",
    18 : " quintillion",
    21 : " sextillion",
    24 : " septillion",
  };

  // noto'gri sonlar uchun___________________________________
  if(text.startsWith("0") || text == "0") {
    String son = int.parse(text).toString();
    String son2 = text.replaceFirst(int.parse(text).toString(),"");
    if(son == "0") {
      result = "nul";
    } else {
      for(int i = 0; i < son2.length; i++) {
        result += "nul ";
      }
      if(son.isEmpty) {
        result = result.substring(0,result.length-1);
      }
      result += numToText(son);
    }
  }
  //_________________________________________________________
  // to'g'ri sonlar uchun____________________________________
  else {
    int sonUzunligi = text.length;
    for(int i = 0; i < sonUzunligi; i++) {
      if((sonUzunligi-i)%3 == 0 && (sonUzunligi-i) != 0 && sonUzunligi >= (sonUzunligi-i)+1) {
        if(darajalar.containsKey(sonUzunligi-i)) {
          result += darajalar[sonUzunligi-i]!;
        } else {
          result += " ?illion";
        }
      }
      if(mapp[((sonUzunligi-(i+1))%3).toString()]![text[i]]! != "" && i != 0) {
        result += " ";
      }
      if(((sonUzunligi-(i+1))%3) == 2 && text[i] == "1" && text[i+1] == "0" && text[i+2] == "0") {
        result += "yuz";
      } else {
        result += mapp[((sonUzunligi-(i+1))%3).toString()]![text[i]]!;
      }
    }
  }
  //_________________________________________________________
  return result;
}