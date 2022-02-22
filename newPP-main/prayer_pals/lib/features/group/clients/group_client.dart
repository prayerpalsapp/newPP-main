import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

//////////////////////////////////////////////////////////////////////////
//
//       Used for creating groups in the group collection
//       Not sure how to implment retrieve, update , or delete
//
//////////////////////////////////////////////////////////////////////////

final groupClientProvider = Provider<GroupClient>((ref) => GroupClient());

class GroupClient {
  GroupClient();
  Future<bool> createGroup(Group group) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(group.groupUID)
          .set(group.toJson());

      await FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(group.creatorUID)
          .collection(StringConstants.myGroupsCollection)
          .doc(group.groupUID)
          .set(group.toJson());

      return true;
    } on FirebaseException catch (e) {
      debugPrint('Error Creating Group: ${e.toString()}');
      return Future.value(false);
    }
  }

  Future<Group> fetchGroup(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(uid)
        .get();
    final group = Group.fromJson(snapshot.data()!);
    return group;
  }

  Future<String> retrieveGroup(Group group) async {
    try {
      final snap = FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(group.creatorUID)
          .collection(StringConstants.groupsCollection)
          .snapshots();
      return snap
          .every((element) => true)
          .toString(); // snap.docs.map((doc) => Group.fromDocument(doc)).toList();
      // not working - try to get this working instead of the list thing  TODO

    } on FirebaseException catch (e) {
      throw Future.value(e.message.toString());
    }
  }

  Future<String> updateGroup(Group group) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(group.groupUID)
          .update(group.toJson());

      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  Future<String> deleteGroup(Group group) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(group.groupUID)
          .delete();
      await FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(group.creatorUID)
          .collection(StringConstants.myGroupsCollection)
          .doc(group.groupUID)
          .delete();

      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message);
    }
  }

  Future<String> updateGroupImage(
      BuildContext context, File imageFile, Group group) async {
    String msg = '';
    Uuid uuid = const Uuid();

    final String fileName = uuid.v1();
    final firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    final firebase_storage.UploadTask uploadTask = storageRef.putFile(
      imageFile,
    );

    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());

    final docRef = FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(group.groupUID);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(docRef, {StringConstants.groupImageURL: url});
      msg = url;
    }).then((value) async {
      final userGroupDocRef = FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(group.creatorUID)
          .collection(StringConstants.userGroupsCollection)
          .doc(group.groupUID);
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction
            .update(userGroupDocRef, {StringConstants.groupImageURL: url});
      });
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: AlertDialog(
              title: const Text(StringConstants.unknownError),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text(StringConstants.okCaps),
                ),
              ],
            ),
          );
        },
      );
    });

    return msg;
  }

  Future<void> addGroupToMyGroups(Group group, String userUID) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(userUID)
        .collection(StringConstants.myGroupsCollection)
        .doc(group.groupUID)
        .set(group.toJson());
  }

  saveGroupDescription(String groupDescription, String groupUID) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(StringConstants.myGroupsCollection)
        .doc(groupUID)
        .update({"description": groupDescription});
    await FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(groupUID)
        .update({"description": groupDescription});
    return;
  }

  Future<bool> amIAMemberOfThisGroup(String groupUID) async {
    final userIsMember = await FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(groupUID)
        .collection(StringConstants.groupMemberCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final userExists = userIsMember.exists;
    return userExists;
  }
}
