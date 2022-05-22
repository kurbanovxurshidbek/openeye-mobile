import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/for_language/load_lang_cubit.dart';
import 'package:key_board_app/cubits/for_language/load_lang_state.dart';
import 'package:key_board_app/views/full_grid_view.dart';

import '../constants/enums.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<LoadLangCubit, LoadLangState>(
        builder: (context, state) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0),
            ),
            body: state.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator.adaptive(),
                        const Text("loading").tr()
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            end: Alignment.topCenter,
                            begin: Alignment.bottomCenter,
                            colors: [
                          Color(0xFF443efc),
                          Color(0xFF52e5de),
                        ])),
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          child: GridView(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            children: [
                              itemGrid(
                                  "voice".tr(),
                                  const Icon(Icons.record_voice_over,
                                      size: 30, color: Colors.white),
                                  ItemOfFullGrid.Voice,
                                  context),
                              itemGrid(
                                  "lang".tr(),
                                  const Icon(Icons.language,
                                      size: 30, color: Colors.white),
                                  ItemOfFullGrid.Lang,
                                  context),
                            ],
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ],
                    )),
          );
        },
      ),
    );
  }
}
