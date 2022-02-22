import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/iap/iap_handler.dart';
import 'package:prayer_pals/core/providers/ppcuser_core_provider.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/repositories/group_repository.dart';
import 'package:prayer_pals/features/group/view/create_group.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Used for creating groups in the groups collection
//
//////////////////////////////////////////////////////////////////////////

final groupControllerProvider =
    ChangeNotifierProvider((ref) => GroupController(ref.read, false));

class GroupController extends ChangeNotifier {
  final Reader _reader;
  bool isEdit;

  GroupController(this._reader, this.isEdit) : super();

  Future<String> deleteGroup(Group group) async {
    return await _reader(groupRepositoryProvider).deleteGroup(group);
  }

  Future<String> updateGroupImage(
      BuildContext context, File imageFile, Group group) async {
    return await _reader(groupRepositoryProvider)
        .updateGroupImage(context, imageFile, group);
  }

  Future<Group> fetchGroup(String uid) async {
    return _reader(groupRepositoryProvider).fetchGroup(uid);
  }

  Stream<QuerySnapshot> fetchMyGroups() {
    return _reader(groupRepositoryProvider).fetchMyGroups();
  }

  checkForGroupCreationCredit(BuildContext context, bool isCreating) async {
    final hasGroupCredits =
        await _reader(groupRepositoryProvider).checkForGroupCreationCredit();
    if (hasGroupCredits) {
      showGroupCreationDialog(context, isCreating);
    } else {
      final purchaseApproved = await IAPHandler.purchaseStartGroup();
      if (purchaseApproved) {
        _reader(ppcUserCoreProvider).incrementGroupCredit();
        showGroupCreationDialog(context, isCreating);
      } else {
        showPPCDialog(context, StringConstants.prayerPals,
            StringConstants.unknownError, null);
      }
    }
  }

  showGroupCreationDialog(
    BuildContext context,
    bool isCreating,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          CreateGroupWidget(context, isCreating: isCreating),
    );
  }

  saveDescriptionForGroup(String groupDescription, String groupUID) async {
    await _reader(groupRepositoryProvider)
        .saveDescriptionForGroup(groupDescription, groupUID);
    setIsEdit(false);
  }

  Future<bool> amIAMemberOfThisGroup(String groupUID) async {
    return await _reader(groupRepositoryProvider)
        .amIAMemberOfThisGroup(groupUID);
  }

  setIsEdit(bool edit) {
    isEdit = edit;
    notify();
  }

  notify() {
    Timer.run(() {
      notifyListeners();
    });
  }
}
