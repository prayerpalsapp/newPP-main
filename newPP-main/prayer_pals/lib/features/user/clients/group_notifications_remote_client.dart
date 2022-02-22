import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';

final groupNotificationsClientProvider =
    Provider((ref) => GroupNotificationsClient());

class GroupNotificationsClient {
  Future<void> addGroupToSubscribedArray(Group group) async {
    var docRef = FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final groupSub = Group(
        groupUID: group.groupUID, groupName: group.groupName, subscribed: true);
    return await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        transaction.update(
          docRef,
          {
            StringConstants.subscribedGroups:
                FieldValue.arrayUnion([groupSub.toJson()]),
          },
        );
      },
    );
  }

  Future<void> removeGroupFromSubscribedArray(Group group) async {
    var docRef = FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final groupSub = Group(
        groupUID: group.groupUID,
        groupName: group.groupName,
        subscribed: false);
    return await FirebaseFirestore.instance.runTransaction(
      (transaction) async {
        transaction.update(
          docRef,
          {
            StringConstants.subscribedGroups:
                FieldValue.arrayRemove([groupSub.toJson()]),
          },
        );
      },
    );
  }

  Future<List<Group>> getGroupsSubscribedTo() async {
    final docSnap = await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<Group> groups = [];
    final user = PPCUser.fromJson(docSnap.data()!);
    user.subscribedGroups.removeAt(0);
    for (var element in user.subscribedGroups) {
      final group = Group.fromJson(element);
      groups.add(group);
    }
    return groups;
  }
}
