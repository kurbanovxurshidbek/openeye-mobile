import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LangUI extends StatelessWidget {
  String lang;
  String hello;
  bool isChackLang;
  Image? icon;
  final textStyle1 = const TextStyle(
      fontSize: 20,
      fontFamily: "Serif",
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontStyle: FontStyle.normal);

  final textStyle2 = const TextStyle(
      fontSize: 14,
      fontFamily: "Serif",
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
      fontStyle: FontStyle.normal);

  LangUI(
      {Key? key,
      required this.hello,
      required this.lang,
      this.icon,
      this.isChackLang = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: icon != null
          ? MediaQuery.of(context).size.width / 2.2
          : MediaQuery.of(context).size.width / 3.5,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: isChackLang
          ? Lottie.asset('assets/lottie/check.json',
              reverse: false, repeat: false, fit: BoxFit.cover)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                icon != null
                    ? icon!
                    : Text(
                        hello,
                        style: textStyle1,
                      ).tr(),
                Text(
                  lang,
                  style: textStyle2,
                ).tr(),
              ],
            ),
      decoration: BoxDecoration(boxShadow: [
        const BoxShadow(
            blurRadius: 2, color: Colors.blueGrey, offset: Offset(2, 0))
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
    );
  }
}
