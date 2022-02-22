import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/event_bus/group_subscribtion_event.dart';
import 'package:prayer_pals/core/event_bus/ppc_event_bus.dart';
import 'package:prayer_pals/core/utils/providers.dart';
import 'package:prayer_pals/core/widgets/avatar_widget.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/providers/search_groups_provider.dart';
import 'group_description_page.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Returns the list of the search results on the search page. Still needs
//      to have sorting setup. when user joins the group, they will be added
//     to groups -> members collection with isPending = true and will have the
//     group name added to their isPending list. When the user clicks on the
//     group tile, they will see the group description page as guest, which
//     filters out some of the views.
//
//////////////////////////////////////////////////////////////////////////

// TODO - verify user is not in group - should not show up, but if it does and user
// hits join group button, they are removed from the group and placed in pending

class PPCSearchGroupsWidget extends HookConsumerWidget {
  final String searchTerm;

  const PPCSearchGroupsWidget({
    Key? key,
    required this.searchTerm,
  }) : super(key: key);
//TODO: search - groups I'm in shouldn't show, gorups I'm not, should
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(searchGroupControllerProvider);

    return FutureBuilder(
      future: ref.read(searchGroupControllerProvider).searchGroups(searchTerm),
      builder: (BuildContext context, AsyncSnapshot<List<Group>> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Group group = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.all(1),
                    child: ListTile(
                      leading: PPCAvatar(
                        radSize: 15,
                        image: StringConstants.groupIcon,
                        networkImage: group.groupImageURL,
                      ),
                      // trailing: Consumer(builder: (ctx, ref, widget) {
                      //   return PPCRoundedButton(
                      //     textColor: Colors.white,
                      //     bgColor: Colors.lightBlueAccent,
                      //     buttonRatio: .4,
                      //     buttonWidthRatio: .15,
                      //     title: StringConstants.join,
                      //     callback: () {
                      //       _joinGroup(context, ref, group);
                      //     },
                      //   );
                      // }),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupDescriptionPage(
                              groupUID: group.groupUID,
                            ),
                          ),
                        );
                      },
                      title: Text(group.groupName),
                    ),
                  );
                },
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(StringConstants.loading),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

_joinGroup(BuildContext ctx, WidgetRef ref, Group group) async {
  //TODO: add subscribe to group
  String srvMsg =
      await ref.read(searchGroupControllerProvider).joinGroup(group);
  if (srvMsg == StringConstants.success) {
    PPCEventBus eventBus = PPCEventBus();
    eventBus.fire(SubscribeToGroupPNEvent(groupId: group.groupUID));
    Navigator.of(ctx).pop();
  } else {
    showPPCDialog(ctx, StringConstants.almostThere, srvMsg, null);
  }
}
