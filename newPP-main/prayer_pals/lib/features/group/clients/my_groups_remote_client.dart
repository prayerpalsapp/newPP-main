import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';

final myGroupsClientProvider =
    Provider<SearchGroupClient>((ref) => SearchGroupClient());

class SearchGroupClient {
  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMyGroups() {
    return FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(StringConstants.myGroupsCollection)
        .snapshots();
  }
}
