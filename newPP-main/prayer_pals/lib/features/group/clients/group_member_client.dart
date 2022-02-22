import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Used for creating members in the group-> members collection
//     and then in the user -> userGroups collection. These are duplicates
//     so that the groups can produce a list independant of the users, and
//     users can produce a list of goups
//
//////////////////////////////////////////////////////////////////////////

final groupMemberClientProvider =
    Provider<GroupMemberClient>((ref) => GroupMemberClient());

class GroupMemberClient {
  Future<String> createGroupMember(GroupMember groupMember) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(groupMember.groupUID)
          .collection(StringConstants.groupMemberCollection)
          .doc(groupMember.groupMemberUID)
          .set(groupMember.toJson());
      final docRef = FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(groupMember.groupUID);

      final docSnap = await docRef.get();

      if (!groupMember.isPending) {
        int memberCount = docSnap.data()![StringConstants.memberCount];
        memberCount = memberCount + 1;
        await FirebaseFirestore.instance.runTransaction(
          (transaction) async {
            transaction
                .update(docRef, {StringConstants.memberCount: memberCount});
          },
        );
      }

      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  Future<List<GroupMember>> retrieveGroupMember(GroupMember groupMember) async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(groupMember.groupUID)
          .collection(StringConstants.groupMemberCollection)
          .get();
      return snap.docs.map((doc) => GroupMember.fromDocument(doc)).toList();
    } on FirebaseException catch (e) {
      throw Future.value(e.message.toString());
    }
  }

  Future<String> updateGroupMember(GroupMember groupMember) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(groupMember.groupUID)
          .collection(StringConstants.groupMemberCollection)
          .doc(groupMember.groupMemberUID)
          .update(groupMember.toJson());
      SetOptions(merge: true);
      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  Future<String> deleteGroupMember(GroupMember groupMember) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(groupMember.groupMemberUID)
          .collection(StringConstants.myGroupsCollection)
          .doc(groupMember.groupUID)
          .delete();
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(groupMember.groupUID)
          .collection(StringConstants.groupMemberCollection)
          .doc(groupMember.groupMemberUID)
          .delete();

      final docRef = FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(groupMember.groupUID);

      final docSnap = await docRef.get();

      int memberCount = docSnap.data()![StringConstants.memberCount];
      final newcount = memberCount - 1;
      await FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          transaction.update(docRef, {StringConstants.memberCount: newcount});
        },
      );

      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message);
    }
  }

  Future<void> addGroupToMyPendingRequests(
      GroupMember groupMember, PPCUser user) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(user.uid)
        .collection(StringConstants.pendingRequestsCollection)
        .doc(groupMember.groupUID)
        .set(groupMember.toJson());
    return;
  }

  Future<String> leaveGroup(String groupUID) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(groupUID)
        .collection(StringConstants.groupMemberCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(StringConstants.myGroupsCollection)
        .doc(groupUID)
        .delete();

    final docRef = FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(groupUID);

    final docSnap = await docRef.get();
    {
      int memberCount = docSnap.data()![StringConstants.memberCount];
      memberCount = memberCount - 1;
      await FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          transaction
              .update(docRef, {StringConstants.memberCount: memberCount});
        },
      );
    }
    return StringConstants.success;
  }
}
