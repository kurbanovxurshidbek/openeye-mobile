import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:key_board_app/cubits/for_lang_page/mainaligment_cubit.dart';
import 'package:key_board_app/cubits/for_language/load_lang_cubit.dart';
import 'package:key_board_app/cubits/for_read_audio_book/reading_audio_book_cubit.dart';
import 'package:key_board_app/cubits/for_take_image/take_image_cubit.dart';
import 'package:key_board_app/cubits/for_text_to_speech/mediaplayer_cubit.dart';
import 'package:key_board_app/cubits/for_speech_to_text/speech_to_text_cubit.dart';
import 'package:key_board_app/cubits/saved_book/saved_books_cubit.dart';
import 'package:key_board_app/pages/home_page.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'cubits/convert_and_reading/convert_and_reading_cubit.dart';
import 'cubits/part_saved_books/part_audio_books_dart_cubit.dart';
import 'pages/change_lang_page.dart';
import 'themes/theme_of_app.dart';

bool haveUser = false;

void main(List<String> args) async {
  /// flutter Binding Initialized
  WidgetsFlutterBinding.ensureInitialized();

  /// fixed portrait mode
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );

  /// easy localization Initialized
  await EasyLocalization.ensureInitialized();

  ///hive service
  await Hive.initFlutter();
  await Hive.openBox(HiveDB.DB_NAME);

  ///have user
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
        child: App(
          connectivity: Connectivity(),
        )),
  );
}

Future<void> starterPage() async {
  var result = HiveDB.loadLangCode();
  if (result != null) {
    haveUser = true;
  }
}

class App extends StatelessWidget {
  final Connectivity connectivity;
  const App({Key? key, required this.connectivity}) : super(key: key);

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
        BlocProvider(create: ((context) {
          return ReadingAudioBookCubit();
        })),
        BlocProvider(create: ((context) {
          return SavedBooksCubit();
        })),
        BlocProvider(create: ((context) {
          return ConvertAndReadingCubit();
        })),
        BlocProvider(create: ((context) {
          return TakeImageCubit();
        })),
        BlocProvider(create: ((context) {
          return PartAudioBooksDartCubit();
        })),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeOf.ligth(),
        home: haveUser ? const HomePage() : LangChangePage(count: 1),
      ),
    );
  }
}
