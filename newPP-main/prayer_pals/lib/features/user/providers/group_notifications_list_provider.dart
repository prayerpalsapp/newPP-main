import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/user/clients/group_notifications_remote_client.dart';

final groupNotificationsProvider =
    ChangeNotifierProvider((ref) => GroupNotificationsController(ref.read));

class GroupNotificationsController extends ChangeNotifier {
  final Reader read;
  GroupNotificationsController(this.read);

  Future<List<Group>> getGroupsSubscribedTo() async {
    return await read(groupNotificationsClientProvider).getGroupsSubscribedTo();
  }

  Future<void> unsubscribeFromAllGroups() async {
    //TODO: test
    List<Group> groups = await getGroupsSubscribedTo();
    for (Group group in groups) {
      unsubscribeFromGroup(group);
    }
    return;
  }

  Future<void> unsubscribeFromGroup(Group group) async {
    return await read(groupNotificationsClientProvider)
        .removeGroupFromSubscribedArray(group);
  }

  Future<void> subscribeToGroup(Group group) async {
    return await read(groupNotificationsClientProvider)
        .addGroupToSubscribedArray(group);
  }

  notify() {
    notifyListeners();
  }
}
