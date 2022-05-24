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
                        const CircularProgressIndicator.adaptive(),
                        const Text("loading").tr()
                      ],
                    ),
                  )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      width: MediaQuery.of(context).size.width,
                      child: GridView(
                        padding: EdgeInsets.all(15),
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
                                  size: 40, color: Colors.blueGrey),
                              ItemOfFullGrid.KeybordItem,
                              context),
                          itemGrid(
                              "text_in_image".tr(),
                              const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.blueGrey),
                              ItemOfFullGrid.TextInImageItem,
                              context),
                          itemGrid(
                              "book".tr(),
                              const Icon(Icons.multitrack_audio,
                                  size: 40, color: Colors.blueGrey),
                              ItemOfFullGrid.BookRecordingItem,
                              context),
                          itemGrid(
                              "settings".tr(),
                              const Icon(
                                Icons.settings,
                                size: 40,
                                color: Colors.blueGrey,
                              ),
                              ItemOfFullGrid.SettingItem,
                              context),
                          itemGrid(
                              "saved_books".tr(),
                              const Icon(
                                Icons.menu_book,
                                size: 40,
                                color: Colors.blueGrey,
                              ),
                              ItemOfFullGrid.ListOfSavedAudioBooks,
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
    );
  }
}
