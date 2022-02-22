// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GroupNotificationsListItem extends HookWidget {
  bool? isSubbed;
  final String groupName;

  GroupNotificationsListItem({
    Key? key,
    required this.isSubbed,
    required this.groupName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(
              "Group: $groupName",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Switch(
          value: isSubbed!,
          onChanged: (value) {
            isSubbed = value;
          },
          activeTrackColor: Colors.blueAccent[100],
          activeColor: Colors.lightBlueAccent,
        ),
      ],
    );
  }
}
