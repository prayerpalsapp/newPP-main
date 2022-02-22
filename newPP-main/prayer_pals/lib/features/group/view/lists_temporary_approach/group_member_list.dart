import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/avatar_widget.dart';
import 'package:prayer_pals/core/widgets/delete_member_dialog.dart';
import 'package:prayer_pals/core/widgets/prevent_zero_admin_dialog.dart';
import 'package:prayer_pals/features/group/clients/group_member_client.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';
import '../create_group_member.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Builds a list of group members for group admin in members section
//     Might be able to find a way to list this differently using client
//
//////////////////////////////////////////////////////////////////////////

class GroupMembers extends HookConsumerWidget {
  final Group group;

  const GroupMembers({Key? key, required this.group}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupMembercontroller = ref.watch(groupMemberControllerProvider);
    final Stream<QuerySnapshot> pendingMembers = FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(group.groupUID)
        .collection(StringConstants.groupMemberCollection)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: pendingMembers,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {}
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(StringConstants.loading),
          );
        } else {
          final data = snapshot.requireData;
          return Container(
            height: SizeConfig.screenHeight! * .4,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                GroupMember groupMember =
                    GroupMember.fromQuerySnapshot(data, index);
                MaterialColor _color;
                groupMember.isAdmin == true
                    ? _color = Colors.lightBlue
                    : _color = Colors.grey;
                return Card(
                  margin: const EdgeInsets.all(1),
                  child: Visibility(
                    visible: !groupMember.isPending,
                    child: ListTile(
                      trailing: SizedBox(
                        width: 48,
                        child: Row(children: [
                          Visibility(
                            visible: !groupMember.isAdmin,
                            child: IconButton(
                              icon: const Icon(CupertinoIcons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                try {
                                  showPPCMemberDeleteDialog(
                                    context,
                                    () async {
                                      await groupMembercontroller
                                          .deleteGroupMember(groupMember);
                                    },
                                  );
                                } catch (e) {
                                  debugPrint(e.toString());
                                  return;
                                }
                              },
                            ),
                          ),
                        ]),
                      ),
                      title: Row(
                        children: [
                          Visibility(
                            visible: !groupMember.isCreated,
                            replacement: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CreateGroupMemberWidget(group: group));
                                // Need to bring over text to edit, not start over
                                //Currently, this will create a new person with a new uid
                                //todo FIX
                              },
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.badge_outlined),
                              color: _color,
                              onPressed: () {
                              /* Removed section for future build - this will allow multiple admins *************
                                if (groupMember.isOwner == true) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          PreventZeroAdminDialog(
                                              groupMember: groupMember));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          _assignAdmin(context, groupMember));
                                  }
                              */
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          PPCAvatar(
                            radSize: 15,
                            image: StringConstants.groupIcon,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            data.docs[index]['groupMemberName'],
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  _assignAdmin(context, groupMember) {
    String _title;
    bool? _isAdmin;
    groupMember.isAdmin == true
        ? _title = StringConstants.removeAdmin
        : _title = StringConstants.assignAdmin;
    return AlertDialog(
      title: Text(_title),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            groupMember.isAdmin == true ? _isAdmin = false : _isAdmin = true;
            // _updateMember(context, groupMember, _isAdmin);
          },
          child: Text(_title),
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

  // _updateMember(BuildContext ctx, GroupMember groupMember, _isAdmin) async {
  //   final srvMsg =
  //       await read(groupMemberControllerProvider).createGroupMember(
  //             groupMember.groupMemberUID,
  //             groupMember.groupMemberName,
  //             groupMember.groupName,
  //             groupMember.groupUID,
  //             _isAdmin,
  //             groupMember.isOwner,
  //             groupMember.isCreated,
  //             groupMember.isInvited,
  //             groupMember.emailAddress,
  //             groupMember.phoneNumber,
  //             groupMember.appNotify,
  //             groupMember.textNotify,
  //             groupMember.emailNotify,
  //             groupMember.isPending,
  //             groupMember.groupImageURL!,
  //           );
  //   if (srvMsg == StringConstants.success) {
  //     Navigator.of(ctx).pop();
  //   } else {
  //     showPPCDialog(ctx, StringConstants.almostThere, srvMsg, null);
  //   }
  // }
}
