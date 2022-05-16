import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:key_board_app/services/hive_service.dart';
import 'package:key_board_app/views/home_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  void initState()async{
    await context.setLocale(Locale(HiveDB.loadLang()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
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
                        "Keyboard". tr(),
                        const Icon(Icons.keyboard,
                            size: 30, color: Colors.white)),
                    itemGrid(
                        "text_in_image".tr(),
                        const Icon(Icons.camera_alt,
                            size: 30, color: Colors.white)),
                    itemGrid(
                        "book".tr(),
                        const Icon(Icons.multitrack_audio,
                            size: 30, color: Colors.white)),
                    itemGrid(
                        "settings".tr(),
                        const Icon(
                          Icons.settings,
                          size: 30,
                          color: Colors.white,
                        )),
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
  }
}
