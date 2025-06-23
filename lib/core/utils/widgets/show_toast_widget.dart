import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastedStates { success, error, warning, info }

showToast({
  required String msg,
  required ToastedStates state,
  ToastGravity gravity = ToastGravity.TOP,
  Toast toastLength = Toast.LENGTH_LONG,
}) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

Color chooseToastColor(ToastedStates states) {
  switch (states) {
    case ToastedStates.success:
      return Colors.green;
    case ToastedStates.error:
      return Colors.red;
    case ToastedStates.warning:
      return Colors.amber;
    case ToastedStates.info:
      return Colors.blue;
  }
}