import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LangUI extends StatelessWidget {
  String lang;
  String hello;
  bool isChackLang;
  final textStyle1 = TextStyle(
      fontSize: 20,
      fontFamily: "Serif",
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(255, 12, 12, 12),
      fontStyle: FontStyle.normal);

  final textStyle2 = TextStyle(
      fontSize: 14,
      fontFamily: "Serif",
      fontWeight: FontWeight.bold,
      color: Color(0xFF204ff5),
      fontStyle: FontStyle.normal);

  LangUI(
      {Key? key,
      required this.hello,
      required this.lang,
      this.isChackLang = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.5,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10),
      child: isChackLang
          ? Lottie.asset('assets/lottie/check.json',
              reverse: false, repeat: false, fit: BoxFit.cover)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Text(
                  hello,
                  style: textStyle1,
                ),
                Text(
                  lang,
                  style: textStyle2,
                )
              ],
            ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            blurRadius: 5,
            color: Color.fromARGB(124, 151, 151, 151),
            offset: Offset(3, 0))
      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
    );
  }
}
