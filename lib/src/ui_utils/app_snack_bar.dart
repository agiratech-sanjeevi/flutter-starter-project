import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  final String? message;
  final String? actionText;
  final VoidCallback? onPressed;
  final bool isPositive;

  const AppSnackBar(
      {required this.message,
      this.actionText,
      this.onPressed,
      this.isPositive = false});

  void showAppSnackBar(BuildContext context) {
    Flushbar(
      backgroundColor: isPositive ? Colors.green : Colors.red,
      flushbarPosition: FlushbarPosition.BOTTOM,
      messageText: Text(
        message!.length < 200
            ? message.toString()
            : message.toString().substring(0, 200),
        textAlign: TextAlign.left,
        softWrap: true,
        style: const TextStyle(color: Colors.white),
      ),
      isDismissible: actionText == null,
      duration: const Duration(seconds: 5),
    ).show(context);
  }
}
