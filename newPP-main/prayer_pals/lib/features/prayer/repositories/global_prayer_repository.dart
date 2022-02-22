import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/clients/global_prayer_client.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';

final globalPrayerRepositoryProvider =
    Provider.autoDispose<GlobalPrayerRepository>(
        (ref) => GlobalPrayerRepositoryImpl(ref.read));

abstract class GlobalPrayerRepository {
  Future<List<Prayer>> retrievePrayers(PrayerType prayerType);
}

class GlobalPrayerRepositoryImpl implements GlobalPrayerRepository {
  final Reader _reader;

  const GlobalPrayerRepositoryImpl(this._reader);

  @override
  Future<List<Prayer>> retrievePrayers(PrayerType prayerType) async {
    return await _reader(globalPrayerClientProvider).retrievePrayer(prayerType);
  }
}
