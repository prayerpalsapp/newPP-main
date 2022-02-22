import 'package:flutter/material.dart';
import 'package:prayer_pals/core/utils/constants.dart';

Future<void> showPPCDialog(BuildContext context, String title,
    String description, VoidCallback? callback) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(StringConstants.okCaps),
            onPressed: () {
              if (callback != null) callback();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
