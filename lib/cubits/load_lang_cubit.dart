import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:key_board_app/cubits/load_lang_state.dart';
import 'package:key_board_app/services/hive_service.dart';


class LoadLangCubit extends Cubit<LoadLangState> {
  BuildContext context;
  LoadLangCubit({required this.context}) : super(LoadLangState(isLoading: false));

  loadedLang()async{
    await context.setLocale(Locale(HiveDB.loadLang()));
    emit(LoadLangState(isLoading: true));
  }

}
