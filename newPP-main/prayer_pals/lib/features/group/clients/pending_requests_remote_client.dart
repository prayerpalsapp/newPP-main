import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';

final pendingRequestsClientProvider =
    Provider<PendingRequestsClient>((ref) => PendingRequestsClient());

class PendingRequestsClient {
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMyPendingRequests() {
    return FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(StringConstants.pendingRequestsCollection)
        .snapshots();
  }

  removePendingRequest(GroupMember groupMember) async {
    return await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(groupMember.groupMemberUID)
        .collection(StringConstants.pendingRequestsCollection)
        .doc(groupMember.groupUID)
        .delete();
  }

  declinePendingRequest(GroupMember groupMember) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(groupMember.groupMemberUID)
        .collection(StringConstants.pendingRequestsCollection)
        .doc(groupMember.groupUID)
        .delete();
    await FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(groupMember.groupUID)
        .collection(StringConstants.groupMemberCollection)
        .doc(groupMember.groupMemberUID)
        .delete();
  }

  removeMyPendingRequestToOtherGroup(GroupMember groupMember) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(groupMember.groupMemberUID)
        .collection(StringConstants.pendingRequestsCollection)
        .doc(groupMember.groupUID)
        .delete();
    await FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(groupMember.groupUID)
        .collection(StringConstants.groupMemberCollection)
        .doc(groupMember.groupMemberUID)
        .delete();
  }
}
