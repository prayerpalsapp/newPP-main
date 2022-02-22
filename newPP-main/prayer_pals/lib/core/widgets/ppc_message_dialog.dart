import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/constants.dart';

class PPCmessage extends HookWidget {
  final String title;

  const PPCmessage({Key? key, required context, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          TextField(
            style: TextStyle(
              fontFamily: 'Helvetica',
            ),
            textInputAction: TextInputAction.done,
            cursorColor: Colors.blue,
            maxLines: 10,
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            //needs to capture message and send through
            //      prefered method; text, email, or app
          },
          child: const Text(StringConstants.send),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(StringConstants.cancel),
        ),
      ],
    );
  }
}
