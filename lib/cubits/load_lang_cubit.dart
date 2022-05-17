import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:key_board_app/cubits/load_lang_state.dart';
import 'package:key_board_app/services/hive_service.dart';


class LoadLangCubit extends Cubit<LoadLangState> {
  BuildContext context;
  String countyCode = "";
  String langCode = "";
  LoadLangCubit({required this.context}) : super(LoadLangState(isLoading: true));

  loadedLang()async{
    countyCode = await HiveDB.loadCountryCode();
    langCode = await HiveDB.loadLangCode()!;
    await context.setLocale(Locale(langCode,countyCode));
    emit(LoadLangState(isLoading: false));
  }

}
