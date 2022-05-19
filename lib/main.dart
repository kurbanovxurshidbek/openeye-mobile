import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:key_board_app/cubits/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/mediaplayer_cubit.dart';
import 'package:key_board_app/cubits/speech_to_text_cubit.dart';
import 'package:key_board_app/pages/home_page.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'cubits/load_lang_cubit.dart';
import 'pages/change_lang_page.dart';
import 'themes/theme_of_app.dart';

bool haveUser=false;

void main(List<String> args) async {
  // flutter Binding Initialized
  WidgetsFlutterBinding.ensureInitialized();

  // fixed portrait mode
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );


  // easy localization Initialized
  await EasyLocalization.ensureInitialized();

  ///hive service
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);

  //have user
  await starterPage();


  runApp(
    // easy localization
    EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
          Locale('uz', 'UZ'),
        ],
        path: 'assets/lang', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: const App()),
  );
}

Future<void> starterPage()async {
 var result =   await HiveDB.loadLangCode();
 if(result !=null){
    haveUser =true;
 }

}
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: ((context) {
          return MainaligmentCubit();
        })),
        BlocProvider(create: ((context) {
          return MediaplayerCubit();
        })),
        BlocProvider(create: ((context) {
          return SpeechToTextCubit(context: context);
        })),
        BlocProvider(create: ((context) {
          return LoadLangCubit(context: context);
        })),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeOf.ligth(),
        home: haveUser?HomePage():LangChangePage(),
      ),
    );
  }
}
