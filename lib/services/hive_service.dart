import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDB{
static String DB_NAME ='openeye';
static Box box  =Hive.box(DB_NAME);

static Future<void> storeLang ( String lang ) async {
 await box.put("language",lang);
}


static String  loadLang(){
  var language =  box.get('language');
  return language;
}
static void removeUser() async {
  box.delete('language');
}
}