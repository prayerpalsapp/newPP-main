import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/providers/ppcuser_core_provider.dart';
import 'package:prayer_pals/features/group/clients/group_client.dart';
import 'package:prayer_pals/features/group/clients/search_group_remote_client.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/providers/my_groups_provider.dart';

//////////////////////////////////////////////////////////////////////////
//
//       used for creating groups in the group collection
//
//////////////////////////////////////////////////////////////////////////

final groupRepositoryProvider = Provider.autoDispose<GroupRepository>(
    (ref) => GroupRepositoryImpl(ref.read));

abstract class GroupRepository {
  Future<bool> createGroup(Group group);
  Future<String> retrieveGroup(Group group);
  Future<String> updateGroup(Group group);
  Future<String> deleteGroup(Group group);
  Future<String> updateGroupImage(
      BuildContext context, File imageFile, Group group);
  Future<Group> fetchGroup(String uid);
  Future<List<Group>> searchGroups(String searchParams);
  Stream<QuerySnapshot> fetchMyGroups();
  saveDescriptionForGroup(String groupDescription, String groupUID);
  Future<bool> checkForGroupCreationCredit();
  Future<bool> amIAMemberOfThisGroup(String groupUID);
}

class GroupRepositoryImpl implements GroupRepository {
  final Reader _reader;
  const GroupRepositoryImpl(this._reader);

  @override
  Future<bool> createGroup(Group group) async {
    return await _reader(groupClientProvider).createGroup(group);
  }

  @override
  Future<String> retrieveGroup(Group group) async {
    return await _reader(groupClientProvider).retrieveGroup(group);
  }

  @override
  Future<String> updateGroup(Group group) async {
    return await _reader(groupClientProvider).updateGroup(group);
  }

  @override
  Future<String> deleteGroup(Group group) async {
    return await _reader(groupClientProvider).deleteGroup(group);
  }

  @override
  Future<String> updateGroupImage(
      BuildContext context, File imageFile, Group group) async {
    return await _reader(groupClientProvider)
        .updateGroupImage(context, imageFile, group);
  }

  @override
  Future<Group> fetchGroup(String uid) async {
    return await _reader(groupClientProvider).fetchGroup(uid);
  }

  @override
  Future<List<Group>> searchGroups(String searchParams) {
    return _reader(searchGroupClientProvider).searchGroups(searchParams);
  }

  @override
  Stream<QuerySnapshot> fetchMyGroups() {
    return _reader(myGroupsControllerProvider).fetchMyGroups();
  }

  @override
  saveDescriptionForGroup(String groupDescription, String groupUID) {
    return _reader(groupClientProvider)
        .saveGroupDescription(groupDescription, groupUID);
  }

  @override
  Future<bool> checkForGroupCreationCredit() async {
    final user = await _reader(ppcUserCoreProvider).currentUserNetworkFetch();
    if (user.groupCreationCredits != null && user.groupCreationCredits! > 0) {
      return true;
    }
    return false;
  }

  @override
  Future<bool> amIAMemberOfThisGroup(String groupUID) async {
    return await _reader(groupClientProvider).amIAMemberOfThisGroup(groupUID);
  }
}

//TODO: test prayerCount incrementing and decrementing in group
//TODO: test memberCount incrementing and decremnting in group
