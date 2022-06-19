import 'package:flutter/material.dart';

abstract class AppButtonStyle {
  static const blueColor = Color(0xFF01B4E4);
  
  static const greyColor = Color.fromARGB(255, 162, 179, 184);

  static final staticlink = ButtonStyle(
    foregroundColor: MaterialStateProperty.all(const Color(0xFF01B4E4)),
    textStyle: MaterialStateProperty.all(
      const TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
    ),
  );
}
