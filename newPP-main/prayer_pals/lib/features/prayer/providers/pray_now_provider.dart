import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/prayer/repositories/pray_now_repository.dart';

final prayerNowProvider = Provider<PrayerNowController>((ref) => PrayerNowController(ref.read));

class PrayerNowController {
  final Reader reader;

  PrayerNowController(this.reader);

  Future<int> currentHoursPrayer() async {
    return await reader(prayerNowRepositoryProvider).currentHoursPrayer();
  }

  Future<void> updateTime(DateTime startTime) async {
    return await reader(prayerNowRepositoryProvider).updateTime(startTime);
  }
}
