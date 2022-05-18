import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_lang_page/mainaligment_state.dart';

class MainaligmentCubit extends Cubit<MainAligmentState> {
  MainaligmentCubit()
      : super(MainAligmentState(
            columnAligment: MainAxisAlignment.spaceBetween,
            bottomUp: false,
            isSpeaking: false,
            chackedItem: 34));

  makeStartPosition(bool ispeaking, {int chackingItem = 34}) {
    emit(MainAligmentState(
        columnAligment: MainAxisAlignment.start,
        bottomUp: true,
        isSpeaking: ispeaking,
        chackedItem: chackingItem));
  }
}
