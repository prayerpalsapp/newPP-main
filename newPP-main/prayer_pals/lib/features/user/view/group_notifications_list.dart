import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/user/providers/group_notifications_list_provider.dart';
import 'package:prayer_pals/features/user/view/group_notifications_list_item.dart';

class GroupNotificationsList extends HookConsumerWidget {
  const GroupNotificationsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupNotificationProvider = ref.watch(groupNotificationsProvider);
    return FutureBuilder(
      future: groupNotificationProvider.getGroupsSubscribedTo(),
      builder: (context, AsyncSnapshot<List<Group>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Group group = snapshot.data![index];
              return Visibility(
                visible: true,
                child: GroupNotificationsListItem(
                  isSubbed: group.subscribed,
                  groupName: group.groupName,
                ),
              );
            },
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
