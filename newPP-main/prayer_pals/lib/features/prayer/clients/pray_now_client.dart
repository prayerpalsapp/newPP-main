import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';

final prayerNowClientProvider =
    Provider<PrayerNowClient>((_) => PrayerNowClient());

class PrayerNowClient {
  Future<int> currentHoursPrayer() async {
    var data = await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    int currentHours = data[StringConstants.hoursPrayer];
    return currentHours;
  }

  Future<void> updateTime(DateTime startTime) async {
    var difference = DateTime.now().difference(startTime);
    num currentHours = 9; // this is a plcaeholder until I can get real data
    var newHoursPrayer = difference.inSeconds + currentHours;
    await FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {StringConstants.hoursPrayer: newHoursPrayer},
    );
    return;
  }
}
