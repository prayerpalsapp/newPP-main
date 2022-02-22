import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/models/group.dart';

final searchGroupClientProvider =
    Provider<SearchGroupClient>((ref) => SearchGroupClient());

class SearchGroupClient {
  Future<List<Group>> searchGroups(String searchParams) async {
    final myGroups = await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(StringConstants.myGroupsCollection)
        .get();

    final groupSearchResults = await FirebaseFirestore.instance
        .collection('groups')
        .where("searchParamsList", arrayContains: searchParams)
        // .where("creatorUID",
        //     isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    final list = groupSearchResults.docs.toList();
    List<Group> groups = [];
    for (var i = 0; i < list.length; i++) {
      // String id = list[i].id;
      // for (var x = 0; i < myGroups.size; i++) {
      //   String groupId = myGroups.docs[x].id;
      //   if (groupId != id) {
      groups.add(Group.fromJson(groupSearchResults.docs[i].data()));
      //   }
      // }
    }
    return groups;
  }
}
