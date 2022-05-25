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
            // extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              shadowColor: Colors.blueGrey,
              backgroundColor: Colors.white,
              foregroundColor: Colors.blueGrey,
            ),
            body: state.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator.adaptive( valueColor:AlwaysStoppedAnimation<Color>(Colors.blueGrey),),
                        SizedBox(height: 10,),
                        const Text("loading",style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold),).tr()
                      ],
                    ),
                  )
                : Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width,
                          child: GridView(
                            padding: EdgeInsets.all(15),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                              mainAxisSpacing: 15,
                              crossAxisSpacing: 15,
                            ),
                            children: [
                              itemGrid(
                                  "voice".tr(),
                                  Icon(Icons.record_voice_over,
                                      size: 30, color: Colors.blueGrey),
                                  ItemOfFullGrid.Voice,
                                  context),
                              itemGrid(
                                  "lang".tr(),
                                  const Icon(Icons.language,
                                      size: 30, color: Colors.blueGrey),
                                  ItemOfFullGrid.Lang,
                                  context),
                            ],
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
