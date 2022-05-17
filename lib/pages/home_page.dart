import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_board_app/cubits/load_lang_cubit.dart';
import 'package:key_board_app/views/home_grid_view.dart';
import '../cubits/load_lang_state.dart';

import '../constants/enums.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
<<<<<<<<< Temporary merge branch 1
  void initState() {
    // await context.setLocale(Locale(HiveDB.loadLang()));
=========
  void initState(){
    BlocProvider.of<LoadLangCubit>(context).loadedLang();
>>>>>>>>> Temporary merge branch 2
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoadLangCubit, LoadLangState>(
  builder: (context, state) {
    return Scaffold(
      body: SafeArea(
        child: state.isLoading? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              Text("loading").tr(),
            ],),): Container(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: [
                    itemGrid(
<<<<<<<<< Temporary merge branch 1
                        "Keyboard".tr(),
=========
                        "keyboard". tr(),
>>>>>>>>> Temporary merge branch 2
                        const Icon(Icons.keyboard,
                            size: 30, color: Colors.white),
                        ItemOfGridHome.KeybordItem),
                    itemGrid(
                        "text_in_image".tr(),
                        const Icon(Icons.camera_alt,
                            size: 30, color: Colors.white),
                        ItemOfGridHome.TextInImageItem),
                    itemGrid(
                        "book".tr(),
                        const Icon(Icons.multitrack_audio,
                            size: 30, color: Colors.white),
                        ItemOfGridHome.BookRecordingItem),
                    itemGrid(
                        "settings".tr(),
                        const Icon(
                          Icons.settings,
                          size: 30,
                          color: Colors.white,
                        ),
                        ItemOfGridHome.SettingItem),
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
