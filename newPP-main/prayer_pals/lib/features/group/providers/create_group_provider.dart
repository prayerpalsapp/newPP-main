import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/event_bus/group_subscribtion_event.dart';
import 'package:prayer_pals/core/event_bus/ppc_event_bus.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/utils/providers.dart';
import 'package:prayer_pals/core/utils/search_array_maker.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';
import 'package:prayer_pals/features/group/repositories/group_repository.dart';
import 'package:prayer_pals/features/user/providers/group_notifications_list_provider.dart';
import 'package:uuid/uuid.dart';

final createGroupProvider = Provider((ref) => CreateGroupProvider(ref.read));

class CreateGroupProvider {
  final Reader read;
  const CreateGroupProvider(this.read);

  Future<bool> createGroup(
    BuildContext context,
    String groupName,
    String tags,
  ) async {
    String message = '';
    bool success = false;
    final serachParamsList = SearchArrayMaker.setSearchParam(groupName);
    final userUID = read(firebaseAuthProvider).currentUser!.uid;

    if (message.isNotEmpty) {
      return Future.value(false);
    } else {
      final groupUID = const Uuid().v1();
      Group group = Group(
        groupUID: groupUID,
        groupName: groupName,
        description: "",
        creatorUID: userUID,
        isPrivate: true,
        searchParamsList: serachParamsList,
        tags: tags,
        memberCount: 0,
        prayerCount: 0,
        subscribed: true,
      );
      success = await read(groupRepositoryProvider).createGroup(group);
      await read(groupNotificationsProvider).subscribeToGroup(group);
      if (success) {
        success = await joinGroup(context, groupUID, groupName);
      } else {
        await showPPCDialog(context, StringConstants.almostThere,
            StringConstants.unknownError, null);
        return false;
      }
    }
    return success;
  }

  Future<bool> joinGroup(BuildContext context, groupId, groupName) async {
    final PPCEventBus _eventBus = PPCEventBus();

    final groupMemberUID = read(firebaseAuthProvider).currentUser!.uid;
    final groupMemberName = read(firebaseAuthProvider).currentUser!.displayName;
    final groupUID = groupId;
    final emailAddress = read(firebaseAuthProvider).currentUser!.email;
    const phoneNumber = "";
    final srvMsg = await read(groupMemberControllerProvider).createGroupMember(
      groupMemberUID,
      groupMemberName!,
      groupName,
      groupUID,
      true,
      true,
      false,
      false,
      emailAddress!,
      phoneNumber,
      true,
      false,
      false,
      false,
      "",
    );
    if (srvMsg == StringConstants.success) {
      _eventBus.fire(SubscribeToGroupPNEvent(groupId: groupUID));
      return true;
    } else {
      await showPPCDialog(context, StringConstants.almostThere, srvMsg, null);
      return false;
    }
  }
}
