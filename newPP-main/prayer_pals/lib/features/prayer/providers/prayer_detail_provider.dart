import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/providers/my_prayer_provider.dart';
import 'package:prayer_pals/features/prayer/repositories/prayer_detail_repository.dart';

final prayerDetailProvider = ChangeNotifierProvider<PrayerDetailController>(
    (ref) => PrayerDetailController(ref.read));

class PrayerDetailController extends ChangeNotifier {
  final Reader _reader;

  PrayerDetailController(this._reader) : super();

  Future<Prayer> fetchPrayer(String uid, bool isGlobal) async {
    return await _reader(prayerDetailRepositoryProvider)
        .fetchPrayer(uid, isGlobal);
  }

  Future<bool> isPrayerInMyPersonalList(Prayer prayer) async {
    return await _reader(prayerDetailRepositoryProvider)
        .isPrayerInMyPersonalList(prayer);
  }

  addPrayerToMyList(Prayer prayer) async {
    await _reader(prayerDetailRepositoryProvider).addPrayerToMyList(prayer);
    _reader(prayerControllerProvider).notify();
    notifyListeners();
  }

  removePrayerFromMyList(Prayer prayer) async {
    await _reader(prayerDetailRepositoryProvider)
        .removePrayerFromMyList(prayer);
    _reader(prayerControllerProvider).notify();
    notifyListeners();
  }

  Future<bool> reportPrayer(Prayer prayer) async {
    return await _reader(prayerDetailRepositoryProvider).reportPrayer(prayer);
  }
}
