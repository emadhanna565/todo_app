import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Row(
          children: [
            Lottie.asset(
              'assets/images/progress_indicator.json',
              height: 60,
              width: 60,
            ),
            SizedBox(
              width: 12,
            ),
            Text(message),
          ],
        ));
      },
      barrierDismissible: false,
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static void showMessage(
    BuildContext context,
    String message, {
    String? postActionName,
    String? nagActionName,
    VoidCallback? postAction,
    VoidCallback? nagAction,
    bool dismissible = false,
  }) {
    List<Widget> actions = [];
    if (postActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            postAction?.call();
          },
          child: Text(postActionName)));
    }
    if (nagActionName != null) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.pop(context);
            nagAction?.call();
          },
          child: Text(nagActionName)));
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(message),
          actions: actions,
        );
      },
      barrierDismissible: dismissible,
    );
  }
}
