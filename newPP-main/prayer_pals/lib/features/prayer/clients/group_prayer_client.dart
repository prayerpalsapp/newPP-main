import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/core/utils/constants.dart';

final groupPrayerClientProvider =
    Provider<GroupPrayerClient>((ref) => GroupPrayerClient());

class GroupPrayerClient {
  Future<String> createPrayer(Prayer prayer, GroupMember groupMember) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(groupMember.groupUID)
          .collection(StringConstants.groupPrayerCollection)
          .doc(prayer.uid)
          .set(prayer.toJson());
      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  Future<List<Prayer>> retrievePrayer(
      String groupId, PrayerType prayerType) async {
    if (prayerType == PrayerType.answered) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(StringConstants.groupsCollection)
            .doc(groupId)
            .collection(StringConstants.groupAnsweredCollection)
            .orderBy("dateCreated", descending: true)
            .get();
        return snap.docs.map((doc) => Prayer.fromDocument(doc)).toList();
      } on FirebaseException catch (e) {
        throw Future.value(e.message.toString());
      }
    } else {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(StringConstants.groupsCollection)
            .doc(groupId)
            .collection(StringConstants.groupPrayerCollection)
            .orderBy("dateCreated", descending: true)
            .get();
        return snap.docs.map((doc) => Prayer.fromDocument(doc)).toList();
      } on FirebaseException catch (e) {
        throw Future.value(e.message.toString());
      }
    }
  }

  Future<String> updatePrayer(Prayer prayer, Group group) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(group.groupUID)
          .collection(StringConstants.groupPrayerCollection)
          .doc(prayer.uid)
          .update(prayer.toJson());
      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  Future<String> deletePrayer(Prayer prayer, Group group) async {
    try {
      await FirebaseFirestore.instance
          .collection(StringConstants.groupsCollection)
          .doc(group.groupUID)
          .collection(StringConstants.groupPrayerCollection)
          .doc(prayer.uid)
          .delete();
      return StringConstants.success;
    } on FirebaseException catch (e) {
      return Future.value(e.message);
    }
  }
}
