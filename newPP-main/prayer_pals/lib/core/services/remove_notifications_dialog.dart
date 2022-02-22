import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/constants.dart';

class RemoveNotificationsDialog extends HookWidget {
  final Function(bool) callback;
  const RemoveNotificationsDialog({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        StringConstants.prayerPals,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
            StringConstants.areYouSureYouWishToDisableAllNotifications,
          ),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            callback(true);
            Navigator.of(context).pop();
          },
          child: const Text(StringConstants.okCaps),
        ),
        ElevatedButton(
          onPressed: () {
            callback(true);
            Navigator.of(context).pop();
          },
          child: const Text(StringConstants.cancel),
        ),
      ],
    );
  }
}
