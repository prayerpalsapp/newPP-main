import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/providers/ppcuser_core_provider.dart';
import 'package:prayer_pals/features/group/providers/create_group_provider.dart';
import 'package:prayer_pals/core/utils/constants.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Creates group and creates first group member as admin and owner
//     isOwner should be used in determining if an admin can resign as admin
//     or kill the group. Owner should assign a new owner when leaving the
//     group or understand that it will kill the group. Multiple admins can be
//     assigned, but only one owner.
//
//////////////////////////////////////////////////////////////////////////

class CreateGroupWidget extends HookConsumerWidget {
  final bool isCreating;
  CreateGroupWidget(BuildContext context, {Key? key, required this.isCreating})
      : super(key: key);

  final TextEditingController _groupNameController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ppcCoreProvider = ref.read(ppcUserCoreProvider);
    return AlertDialog(
      title: const Text(
        StringConstants.createGroup,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            style: const TextStyle(
              fontFamily: 'Helvetica',
            ),
            textInputAction: TextInputAction.done,
            controller: _groupNameController,
            decoration: const InputDecoration(
              hintText: StringConstants.groupName,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () async {
            final success = await ref
                .read(createGroupProvider)
                .createGroup(context, _groupNameController.text, "");
            if (success) {
              ppcCoreProvider.decrementGroupCredit();
              Navigator.of(context).pop();
            }
          },
          child: const Text(StringConstants.save),
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
