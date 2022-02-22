import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/providers/ppcuser_core_provider.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';

final prayerDetailClientProvider =
    Provider<PrayerDetailClient>((ref) => PrayerDetailClient(ref.read));

class PrayerDetailClient {
  final Reader read;

  PrayerDetailClient(this.read);

  Future<Prayer> fetchPrayer(String uid, bool isGlobal) async {
    DocumentReference<Map<String, dynamic>> docRef;
    if (!isGlobal) {
      docRef = FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(StringConstants.myPrayersCollection)
          .doc(uid);
    } else {
      docRef = FirebaseFirestore.instance
          .collection(StringConstants.globalPrayersCollection)
          .doc(uid);
    }
    final response = await docRef.get();
    return Prayer.fromJson(response.data()!);
  }

// ***************************** Adding retrieve group prayers **************************
Future<Prayer> fetchGroupPrayer(String uid, bool isGlobal) async {
    DocumentReference<Map<String, dynamic>> docRef;
    if (!isGlobal) {
      docRef = FirebaseFirestore.instance
          .collection(StringConstants.usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(StringConstants.myPrayersCollection)
          .doc(uid);
    } else {
      docRef = FirebaseFirestore.instance
          .collection(StringConstants.globalPrayersCollection)
          .doc(uid);
    }
    final response = await docRef.get();
    return Prayer.fromJson(response.data()!);
  }
// ***************************** Adding retrieve group prayers **************************











  Future<bool> reportPrayer(Prayer prayer) async {
    final docRef = FirebaseFirestore.instance
        .collection(StringConstants.reportedPrayersCollection)
        .doc(prayer.uid);
    final doc = await docRef.get();
    PPCUser currentUser =
        await read(ppcUserCoreProvider).currentUserNetworkFetch();
    if (doc.exists) {
      //this prayer has been reported before, but if not by currentuser, increment report count
      // and add user to 'reportedBy' array
      Prayer reportedPrayer = Prayer.fromJson(doc.data()!);

      if (reportedPrayer.reportedBy != null &&
          reportedPrayer.reportedBy!.isNotEmpty &&
          !reportedPrayer.reportedBy!.contains(currentUser.uid)) {
        //report the prayer
        int reportCount = reportedPrayer.reportCount ??= 0;

        await FirebaseFirestore.instance.runTransaction(
          (transaction) async {
            transaction.update(
              docRef,
              {
                StringConstants.reportedBy:
                    FieldValue.arrayUnion([currentUser.uid]),
                StringConstants.reportCount: reportCount + 1,
              },
            );
          },
        );
        return true;
      } else {
        return true;
      }
    } else {
      //first time reporting this prayer ever
      int reportCount = prayer.reportCount ??= 1;
      prayer.reportedBy ??= [currentUser.uid];
      prayer.reportCount = reportCount;
      FirebaseFirestore.instance
          .collection(StringConstants.reportedPrayersCollection)
          .doc(prayer.uid)
          .set(prayer.toJson());
    }
    return true;
  }

  Future<bool> isPrayerInMyPersonalList(Prayer prayer) async {
    PPCUser currentUser =
        await read(ppcUserCoreProvider).currentUserNetworkFetch();
    final docRef = await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(currentUser.uid)
        .collection(StringConstants.myPrayersCollection)
        .doc(prayer.uid)
        .get();
    if (docRef.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> addPrayerToMyList(Prayer prayer) async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(userUID)
        .collection(StringConstants.myPrayersCollection)
        .doc(prayer.uid)
        .set(prayer.toJson());
    return true;
  }

  Future<bool> removePrayerFromMyList(Prayer prayer) async {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(userUID)
        .collection(StringConstants.myPrayersCollection)
        .doc(prayer.uid)
        .delete();
    return true;
  }
}
