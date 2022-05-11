import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Text(
          "hello",
          style: Theme.of(context).textTheme.headline1,
        ).tr(),
      )),
    );
  }
}
