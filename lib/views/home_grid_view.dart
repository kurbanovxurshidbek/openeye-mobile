import 'package:flutter/material.dart';

Widget itemGrid(String title, Icon icon) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 5, color: Colors.white24),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    ),
  );
}