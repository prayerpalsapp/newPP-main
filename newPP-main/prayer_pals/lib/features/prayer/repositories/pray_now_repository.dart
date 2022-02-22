import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/prayer/clients/pray_now_client.dart';

final prayerNowRepositoryProvider = Provider.autoDispose<PrayerNowRepository>(
    (ref) => PrayerNowRepositoryImpl(ref.read));

abstract class PrayerNowRepository {
  Future<int> currentHoursPrayer();
  Future<void> updateTime(DateTime startTime);
}

class PrayerNowRepositoryImpl implements PrayerNowRepository {
  final Reader reader;

  PrayerNowRepositoryImpl(this.reader);

  @override
  Future<int> currentHoursPrayer() async {
    return await reader(prayerNowClientProvider).currentHoursPrayer();
  }

  @override
  Future<void> updateTime(DateTime startTime) async {
    return await reader(prayerNowClientProvider).updateTime(startTime);
  }
}
