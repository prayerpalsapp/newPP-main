import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/core/utils/constants.dart';

final prayerClientProvider = Provider<PrayerClient>((ref) => PrayerClient());

class PrayerClient {
  Future<String> createPrayer(Prayer prayer) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(prayer.creatorUID)
          .collection(StringConstants.myPrayersCollection)
          .doc(prayer.uid)
          .set(prayer.toJson());
      if (prayer.isGlobal) _addPrayerToGlobalPrayers(prayer);
      if (prayer.groups.isNotEmpty) _addPrayerToGroups(prayer);
      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  _addPrayerToGlobalPrayers(Prayer prayer) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.globalPrayersCollection)
        .doc(prayer.uid)
        .set(prayer.toJson());
  }

  _addPrayerToGroups(Prayer prayer) {
    for (Group group in prayer.groups) {
      _triggerGroupPrayerUpload(group, prayer);
    }
  }

  addPrayersToGroups(Prayer prayer, List<Group> groups) {
    for (var group in groups) {
      _triggerGroupPrayerUpload(group, prayer);
    }
  }

  deletePrayerFromGroups(Prayer prayer, List<Group> groups) {
    for (var group in groups) {
      _triggerGroupPrayerDelete(group, prayer);
    }
  }

  _triggerGroupPrayerUpload(Group group, Prayer prayer) async {
    FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(group.groupUID)
        .collection(StringConstants.groupPrayerCollection)
        .doc(prayer.uid)
        .set(prayer.toJson());

    final groupDocRef = FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(group.groupUID);

    final doc = await groupDocRef.get();
    final prayerCount = doc['prayerCount'];

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(groupDocRef, {
        StringConstants.prayerCount: prayerCount + 1,
      });
    });
  }

  _triggerGroupPrayerDelete(Group group, Prayer prayer) async {
    FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(group.groupUID)
        .collection(StringConstants.groupPrayerCollection)
        .doc(prayer.uid)
        .delete();

    final groupDocRef = FirebaseFirestore.instance
        .collection(StringConstants.groupsCollection)
        .doc(group.groupUID);

    final doc = await groupDocRef.get();
    final prayerCount = doc['prayerCount'];

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(groupDocRef, {
        StringConstants.prayerCount: prayerCount - 1,
      });
    });
  }

  Future<List<Prayer>> retrievePrayer(PrayerType prayerType) async {
    if (prayerType == PrayerType.answered) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(StringConstants.usersCollection)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(StringConstants.answeredPrayersCollection)
            .orderBy("dateCreated", descending: true)
            .get();
        return snap.docs.map((doc) => Prayer.fromDocument(doc)).toList();
      } on FirebaseException catch (e) {
        throw Future.value(e.message.toString());
      }
    } else {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(StringConstants.usersCollection)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(StringConstants.myPrayersCollection)
            .orderBy("dateCreated", descending: true)
            .get();
        return snap.docs.map((doc) => Prayer.fromDocument(doc)).toList();
      } on FirebaseException catch (e) {
        throw Future.value(e.message.toString());
      }
    }
  }

  Future<String> updatePrayer(
    Prayer prayer,
    PrayerType prayerType,
    List<Group> groupsToRemoveFrom,
    List<Group> groupsToAddTo,
  ) async {
    if (prayerType == PrayerType.answered) {
      try {
        await FirebaseFirestore.instance
            .collection(StringConstants.usersCollection)
            .doc(prayer.creatorUID)
            .collection(StringConstants.answeredPrayersCollection)
            .doc(prayer.uid)
            .set(prayer.toJson());
        await FirebaseFirestore.instance
            .collection(StringConstants.usersCollection)
            .doc(prayer.creatorUID)
            .collection(StringConstants.myPrayersCollection)
            .doc(prayer.uid)
            .delete();
        if (prayer.isGlobal) {
          //TODO Need to check if it once was shared global, but is no longer shared
          // if not, then it needs to be deleted from global
          await FirebaseFirestore.instance
              .collection(StringConstants.globalAnsweredCollection)
              .doc(prayer.uid)
              .set(prayer.toJson());
        }
        await FirebaseFirestore.instance
            .collection(StringConstants.globalPrayersCollection)
            .doc(prayer.uid)
            .delete();

        if (groupsToRemoveFrom.isNotEmpty) {
          await deletePrayerFromGroups(prayer, groupsToRemoveFrom);
        }

        if (groupsToAddTo.isNotEmpty) {
          await addPrayersToGroups(prayer, groupsToAddTo);
        }

        return StringConstants.success;
      } on FirebaseException catch (e) {
        return Future.value(e.message.toString());
      }
    } else {
      try {
        await FirebaseFirestore.instance
            .collection(StringConstants.usersCollection)
            .doc(prayer.creatorUID)
            .collection(StringConstants.myPrayersCollection)
            .doc(prayer.uid)
            .set(prayer.toJson());
        if (prayer.isGlobal) {
          //TODO Need to check if it once was shared global, but is no longer shared
          // if not, then it needs to be deleted from global
          await FirebaseFirestore.instance
              .collection(StringConstants.globalPrayersCollection)
              .doc(prayer.uid)
              .set(prayer.toJson());
        }

        if (groupsToRemoveFrom.isNotEmpty) {
          await deletePrayerFromGroups(prayer, groupsToRemoveFrom);
        }

        if (groupsToAddTo.isNotEmpty) {
          await addPrayersToGroups(prayer, groupsToAddTo);
        }
        return StringConstants.success;
      } on FirebaseException catch (e) {
        return Future.value(e.message.toString());
      }
    }
  }

  Future<void> makeAnsweredPrayerUnanswered(Prayer prayer) async {
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(prayer.creatorUID)
        .collection(StringConstants.myPrayersCollection)
        .doc(prayer.uid)
        .set(prayer.toJson());
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(prayer.creatorUID)
        .collection(StringConstants.answeredPrayersCollection)
        .doc(prayer.uid)
        .delete();
    if (prayer.isGlobal) {
      await FirebaseFirestore.instance
          .collection(StringConstants.globalPrayersCollection)
          .doc(prayer.uid)
          .set(prayer.toJson());
      await FirebaseFirestore.instance
          .collection(StringConstants.globalAnsweredCollection)
          .doc(prayer.uid)
          .delete();
    }
    return;
  }

  Future<String> deletePrayer(Prayer prayer, PrayerType prayerType) async {
    try {
      if (prayerType == PrayerType.answered) {
        await FirebaseFirestore.instance
            .collection(StringConstants.usersCollection)
            .doc(prayer.creatorUID)
            .collection(StringConstants.answeredPrayersCollection)
            .doc(prayer.uid)
            .delete();
        //TODO: test that you can only delete a prayer that is global if it's yours
        //TODO: test deleting a prayer from my prayers that is global and not yours
        if (prayer.isGlobal &&
            prayer.creatorUID == FirebaseAuth.instance.currentUser!.uid) {
          await FirebaseFirestore.instance
              .collection(StringConstants.globalAnsweredCollection)
              .doc(prayer.uid)
              .delete();
        }
      } else {
        await FirebaseFirestore.instance
            .collection(StringConstants.usersCollection)
            .doc(prayer.creatorUID)
            .collection(StringConstants.myPrayersCollection)
            .doc(prayer.uid)
            .delete();
        //TODO: test that you can only delete a prayer that is global if it's yours
        //TODO: test deleting a prayer from my prayers that is global and not yours
        if (prayer.isGlobal &&
            prayer.creatorUID == FirebaseAuth.instance.currentUser!.uid) {
          await FirebaseFirestore.instance
              .collection(StringConstants.globalPrayersCollection)
              .doc(prayer.uid)
              .delete();
        }
      }
      if (prayer.groups.isNotEmpty) {
        deletePrayerFromGroups(prayer, prayer.groups);
      }
      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message);
    }
  }

  Future<List<Group>> fetchGroupsForCurrentUser() async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    List<Group> groups = [];

    final querySnap = await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(userUID)
        .collection(StringConstants.myGroupsCollection)
        .get();
    for (var doc in querySnap.docs) {
      final group = Group.fromJson(doc.data());
      groups.add(group);
    }
    return groups;
  }
}
