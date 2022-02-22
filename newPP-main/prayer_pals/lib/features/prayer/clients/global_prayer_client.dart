import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/core/utils/constants.dart';

final globalPrayerClientProvider =
    Provider<GlobalPrayerClient>((ref) => GlobalPrayerClient());

class GlobalPrayerClient {
  Future<List<Prayer>> retrievePrayer(PrayerType prayerType) async {
    if (prayerType == PrayerType.answered) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(StringConstants.globalAnsweredCollection)
            .orderBy("dateCreated", descending: true)
            .get();
        return snap.docs.map((doc) => Prayer.fromDocument(doc)).toList();
      } on FirebaseException catch (e) {
        throw Future.value(e.message.toString());
      }
    } else {
      try {
        final snap = await FirebaseFirestore.instance
            .collection(StringConstants.globalPrayersCollection)
            .orderBy("dateCreated", descending: true)
            .get();
        return snap.docs.map((doc) => Prayer.fromDocument(doc)).toList();
      } on FirebaseException catch (e) {
        throw Future.value(e.message.toString());
      }
    }
  }
}
