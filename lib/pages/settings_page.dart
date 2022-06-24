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
              title: Text("settings",style: TextStyle(fontSize: 20),).tr(),
              centerTitle: true,
            ),
            body: state.isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator.adaptive(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueGrey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "loading",
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        ).tr()
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
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepOrangeAccent,
                                        offset: const Offset(
                                          0.0,
                                          3.0,
                                        ),
                                        blurRadius: 3.0,
                                        spreadRadius: 0.1,
                                      ), //BoxShadow
                                     //BoxShadow
                                    ],
                                    borderRadius: BorderRadius.circular(15),

                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/voice.png",
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                                child:
                              itemGrid(
                                  "voice".tr(),

                                  ItemOfFullGrid.Voice,
                                  context),),
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pinkAccent.shade100,
                                        offset: const Offset(
                                          0.0,
                                          3.0,
                                        ),
                                        blurRadius: 3.0,
                                        spreadRadius: 0.1,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        // blurRadius: 1.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                    borderRadius: BorderRadius.circular(15),

                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/lang.png",
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                                child: itemGrid(
                                    "lang".tr(),

                                    ItemOfFullGrid.Lang,
                                    context),
                              ),
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
