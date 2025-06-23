import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

enum ToastedStates { success, error, warning, info }

void showToast({
  required String msg,
  required ToastedStates state,
  ToastPosition position = ToastPosition.top,
  Duration duration = const Duration(seconds: 5),
}) {
  showToastWidget(
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 40.0),
      decoration: BoxDecoration(
        color: chooseToastColor(state),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Text(
        msg,
        style: const TextStyle(color: Colors.white, fontSize: 16.0),
      ),
    ),
    position: position,
    duration: duration,
    dismissOtherToast: true,
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