import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/cubits/for_language/load_lang_cubit.dart';
import 'package:key_board_app/cubits/for_language/load_lang_state.dart';
import 'package:key_board_app/cubits/for_text_to_speech/mediaplayer_cubit.dart';
import 'package:key_board_app/views/full_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<LoadLangCubit>(context).loadedLang();

    BlocProvider.of<MediaplayerCubit>(context)
        .onComplatedAudioAndStart(context, 8);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadLangCubit, LoadLangState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: state.isLoading
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        width: MediaQuery.of(context).size.width,
                        child: Column(

                          children: [
                            Expanded(
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 15,right: 15,left: 15),
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.pink,
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
                                        "assets/images/keybrd.png",
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                                child:itemGrid(
                                    "keyboard".tr(),
                                    ItemOfFullGrid.KeybordItem,
                                    context),
                              )
                            ),
                            Expanded(
                              child: Container(

                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepPurple,
                                        offset: const Offset(
                                          0.0,
                                          3.0,
                                        ),
                                        blurRadius: 3.0,
                                        spreadRadius: 0.1,
                                      ), //BoxShadow
                                      BoxShadow(
                                        // color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        // blurRadius: 1.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                    borderRadius: BorderRadius.circular(15),

                                    image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/camera.png",
                                ),
                                fit: BoxFit.cover,
                              )), width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 15,right: 15,left: 15),
                                child: itemGrid(
                                    "text_in_image".tr(),
                                    ItemOfFullGrid.TextInImageItem,
                                    context),
                              ),
                            ),
                            Expanded(
                              child: Container(decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.greenAccent
                                      ,
                                      offset: const Offset(
                                        0.0,
                                        3.0,
                                      ),
                                      blurRadius: 3.0,
                                      spreadRadius: 0.1,
                                    ), //BoxShadow
                                    BoxShadow(
                                      // color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      // blurRadius: 1.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  borderRadius: BorderRadius.circular(15),

                                  image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/book.png",
                                ),
                                fit: BoxFit.cover,
                              )),
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 15,right: 15,left: 15),
                                child: itemGrid(
                                    "book".tr(),

                                    ItemOfFullGrid.BookRecordingItem,
                                    context),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(

                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.deepPurpleAccent,
                                              offset: const Offset(
                                                0.0,
                                                3.0,
                                              ),
                                              blurRadius: 3.0,
                                              spreadRadius: 0.1,
                                            ), //BoxShadow
                                            BoxShadow(
                                              // color: Colors.white,
                                              offset: const Offset(0.0, 0.0),
                                              // blurRadius: 1.0,
                                              spreadRadius: 0.0,
                                            ), //BoxShadow
                                          ],
                                          borderRadius: BorderRadius.circular(15),

                                          image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/setting.png",
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 15,right: 7,left: 15,bottom: 0),
                                      child: itemGrid(
                                          "settings".tr(),

                                          ItemOfFullGrid.SettingItem,
                                          context),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blueGrey.shade700,
                                            offset: const Offset(
                                              0.0,
                                              3.0,
                                            ),
                                            blurRadius: 3.0,
                                            spreadRadius: 0.1,
                                          ), //BoxShadow
                                          BoxShadow(
                                            // color: Colors.white,
                                            offset: const Offset(0.0, 0.0),
                                            // blurRadius: 1.0,
                                            spreadRadius: 0.0,
                                          ), //BoxShadow
                                        ],
                                        borderRadius: BorderRadius.circular(15),

                                        image: DecorationImage(
                                      image: AssetImage(
                                        "assets/images/saved.png",
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(top: 15,right: 15,left: 7,bottom: 0),
                                      child: itemGrid(
                                          "saved_books".tr(),

                                          ItemOfFullGrid.ListOfSavedAudioBooks,
                                          context),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          ],

                        ),
                      ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }
}
