import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';

class PreventZeroAdminDialog extends HookWidget {
  final GroupMember groupMember;

  const PreventZeroAdminDialog({Key? key, required this.groupMember})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(StringConstants.ownerMessage),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(StringConstants.okCaps),
        ),
      ],
    );
  }
}
