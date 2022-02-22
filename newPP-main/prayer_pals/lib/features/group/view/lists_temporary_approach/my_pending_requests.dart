import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/widgets/avatar_widget.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/providers/pending_requests_provider.dart';
import '../group_description_page.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Makes a list of all the groups I am waiting to be accepted to
//     - this is a duplicate collection from groups. In Firebase, this is
//     the same list as myGroups. The only change is the flag isPending = true
//
//////////////////////////////////////////////////////////////////////////

class PendingRequests extends HookConsumerWidget {
  const PendingRequests({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequestsProvider = ref.watch(pendingRequestProvider);
    return StreamBuilder<QuerySnapshot>(
        stream: pendingRequestsProvider.fetchMyPendingRequests(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {}
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(StringConstants.loading),
            );
          } else {
            final data = snapshot.requireData;
            return Container(
                height: SizeConfig.screenHeight! * .17,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ListView.builder(
                    itemCount: data.size,
                    itemBuilder: (context, index) {
                      GroupMember groupMember =
                          GroupMember.fromQuerySnapshot(data, index);

                      return Card(
                          margin: const EdgeInsets.all(1),
                          child: Visibility(
                            visible: groupMember.isPending,
                            child: ListTile(
                                leading: PPCAvatar(
                                    radSize: 15,
                                    image: StringConstants.groupIcon),
                                trailing: SizedBox(
                                  width: 96,
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible: groupMember.isInvited,
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        child: IconButton(
                                            icon: const Icon(Icons.check),
                                            color: Colors.green,
                                            onPressed: () {
                                              _updateGroups(
                                                  context, ref, groupMember);
                                            }),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        color: Colors.red,
                                        onPressed: () async {
                                          try {
                                            pendingRequestsProvider
                                                .removeMyPendingRequestToOtherGroup(
                                                    groupMember);
                                            return;
                                          } catch (e) {
                                            debugPrint(e.toString());
                                            return;
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                title: Text(data.docs[index]['groupName']),
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection(
                                          StringConstants.groupsCollection)
                                      .where(FieldPath.documentId,
                                          isEqualTo: groupMember.groupUID)
                                      .get()
                                      .then((event) {
                                    if (event.docs.isNotEmpty) {
                                      Map<String, dynamic> _group =
                                          event.docs.single.data();
                                      Group group = Group(
                                        groupUID: _group["uid"],
                                        groupName: _group["groupName"],
                                        description: _group["description"],
                                        creatorUID: _group["creatorUID"],
                                        isPrivate: _group["isPrivate"],
                                        tags: _group["tags"],
                                        memberCount: _group['memberCount'],
                                        prayerCount: _group['prayerCount'],
                                      );
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GroupDescriptionPage(
                                            groupUID: group.groupUID,
                                          ),
                                        ),
                                      );
                                    }
                                  }).catchError((e) {
                                    debugPrint("error fetching data: $e");
                                  });
                                }),
                          ));
                    }));
          }
        });
  }
}

_updateGroups(
  BuildContext ctx,
  WidgetRef ref,
  GroupMember groupMember,
) async {
  final srvMsg =
      await ref.read(groupMemberControllerProvider).createGroupMember(
            groupMember.groupMemberUID,
            groupMember.groupMemberName,
            groupMember.groupName,
            groupMember.groupUID,
            false,
            false,
            false,
            false,
            groupMember.emailAddress,
            groupMember.phoneNumber,
            true,
            false,
            false,
            false,
            groupMember.groupImageURL!,
          );
  if (srvMsg == StringConstants.success) {
  } else {
    showPPCDialog(ctx, StringConstants.almostThere, srvMsg, null);
  }
}
