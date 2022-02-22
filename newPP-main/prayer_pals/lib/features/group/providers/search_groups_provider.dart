import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/providers.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';
import 'package:prayer_pals/features/group/repositories/group_repository.dart';

final searchGroupControllerProvider =
    ChangeNotifierProvider((ref) => SearchGroupController(ref.read));

class SearchGroupController with ChangeNotifier {
  final Reader reader;
  SearchGroupController(this.reader);

  Future<List<Group>> searchGroups(String searchParams) {
    return reader(groupRepositoryProvider).searchGroups(searchParams);
  }

  Future<String> joinGroup(Group group) async {
    final groupMemberUID = reader(firebaseAuthProvider).currentUser!.uid;
    final groupMemberName =
        reader(firebaseAuthProvider).currentUser!.displayName;
    final groupUID = group.groupUID;
    final emailAddress = reader(firebaseAuthProvider).currentUser!.email;
    const phoneNumber = "";
    final srvMsg =
        await reader(groupMemberControllerProvider).createGroupMember(
      groupMemberUID,
      groupMemberName!,
      group.groupName,
      groupUID,
      false,
      false,
      false,
      false,
      emailAddress!,
      phoneNumber,
      true,
      false,
      false,
      true,
      "",
    );

    return srvMsg;
  }

  notify() {
    notifyListeners();
  }
}
