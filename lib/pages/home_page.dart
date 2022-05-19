import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/constants/enums.dart';
import 'package:key_board_app/cubits/for_language/load_lang_cubit.dart';
import 'package:key_board_app/cubits/for_language/load_lang_state.dart';
import 'package:key_board_app/views/home_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<LoadLangCubit>(context).loadedLang();
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
                      mainAxisAlignment: MainAxisAlignment.start,
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
                                  "keyboard".tr(),
                                  const Icon(Icons.keyboard,
                                      size: 30, color: Colors.white),
                                  ItemOfGridHome.KeybordItem,context),
                              itemGrid(
                                  "text_in_image".tr(),
                                  const Icon(Icons.camera_alt,
                                      size: 30, color: Colors.white),
                                  ItemOfGridHome.TextInImageItem,context),
                              itemGrid(
                                  "book".tr(),
                                  const Icon(Icons.multitrack_audio,
                                      size: 30, color: Colors.white),
                                  ItemOfGridHome.BookRecordingItem,context),
                              itemGrid(
                                  "settings".tr(),
                                  const Icon(
                                    Icons.settings,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  ItemOfGridHome.SettingItem,context),
                            ],
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
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
