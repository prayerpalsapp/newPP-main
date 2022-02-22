import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/prayer/clients/prayer_detail_client.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';

final prayerDetailRepositoryProvider =
    Provider.autoDispose<PrayerDetailRepository>(
        (ref) => PrayerDetailRepositoryImpl(ref.read));

abstract class PrayerDetailRepository {
  Future<Prayer> fetchPrayer(String id, bool isGlobal);
  Future<bool> reportPrayer(Prayer prayer);
  Future<bool> isPrayerInMyPersonalList(Prayer prayer);
  Future<bool> addPrayerToMyList(Prayer prayer);
  Future<bool> removePrayerFromMyList(Prayer prayer);
}

class PrayerDetailRepositoryImpl implements PrayerDetailRepository {
  final Reader read;
  PrayerDetailRepositoryImpl(this.read);

  @override
  Future<Prayer> fetchPrayer(String id, bool isGlobal) async {
    return await read(prayerDetailClientProvider).fetchPrayer(id, isGlobal);
  }

  @override
  Future<bool> reportPrayer(Prayer prayer) async {
    return await read(prayerDetailClientProvider).reportPrayer(prayer);
  }

  @override
  Future<bool> isPrayerInMyPersonalList(Prayer prayer) async {
    return await read(prayerDetailClientProvider)
        .isPrayerInMyPersonalList(prayer);
  }

  @override
  Future<bool> addPrayerToMyList(Prayer prayer) async {
    return await read(prayerDetailClientProvider).addPrayerToMyList(prayer);
  }

  @override
  Future<bool> removePrayerFromMyList(Prayer prayer) async {
    return await read(prayerDetailClientProvider)
        .removePrayerFromMyList(prayer);
  }
}
