import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewUtils {
  static showSnackBar({required BuildContext context, required String text}) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showToast(
      {required BuildContext context,
      required String text,
      Color backgroundColor = const Color(0xAA383737),
      Color textColor = const Color(0xFFFFFFFF)}) {
    Fluttertoast.showToast(
      msg: text,
      timeInSecForIosWeb: 3,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
