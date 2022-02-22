import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Used by admin to create user that does not have the app. They can
//     get prayers sent to them through email. They are not real users
//     and I need to think about making them real or looking for conflicting
//     email addresses. Not sure at this moment what I want to do
//
//////////////////////////////////////////////////////////////////////////

class CreateGroupMemberWidget extends HookConsumerWidget {
  final Group group;

  CreateGroupMemberWidget({Key? key, context, required this.group})
      : super(key: key);

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailAddressController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text(
        StringConstants.createMember,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(children: [
            TextField(
              style: const TextStyle(
                fontFamily: 'Helvetica',
              ),
              textInputAction: TextInputAction.done,
              controller: _userNameController,
              decoration: const InputDecoration(
                hintText: StringConstants.username,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextField(
              style: const TextStyle(
                fontFamily: 'Helvetica',
              ),
              textInputAction: TextInputAction.done,
              controller: _emailAddressController,
              decoration: const InputDecoration(
                hintText: StringConstants.emailAddress,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
            )
          ])
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            _createMember(context, ref, group);
          },
          child: const Text(StringConstants.create),
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

  _createMember(BuildContext ctx, WidgetRef ref, group) async {
    Uuid uuid = const Uuid();
    String createdMemberId = uuid.v1();
    final groupMemberName = _userNameController.text;
    final emailAddress = _emailAddressController.text;
    const phoneNumber = "";
    final srvMsg = await ref
        .read(groupMemberControllerProvider)
        .createGroupMember(
            createdMemberId,
            groupMemberName,
            group.groupName,
            group.uid,
            false,
            false,
            true,
            false,
            emailAddress,
            phoneNumber,
            false,
            false,
            true,
            false,
            "");
    if (srvMsg == StringConstants.success) {
      Navigator.of(ctx).pop();
    } else {
      showPPCDialog(ctx, StringConstants.almostThere, srvMsg, null);
    }
  }
}
