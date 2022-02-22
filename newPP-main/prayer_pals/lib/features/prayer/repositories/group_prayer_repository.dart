import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/clients/group_prayer_client.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';

final groupPrayerRepositoryProvider =
    Provider.autoDispose<GroupPrayerRepository>(
        (ref) => GroupPrayerRepositoryImpl(ref.read));

abstract class GroupPrayerRepository {
  Future<List<Prayer>> retrievePrayers(group, PrayerType prayerType);
}

class GroupPrayerRepositoryImpl implements GroupPrayerRepository {
  final Reader _reader;

  const GroupPrayerRepositoryImpl(this._reader);

  @override
  Future<List<Prayer>> retrievePrayers(group, PrayerType prayerType) async {
    return await _reader(groupPrayerClientProvider).retrievePrayer(group, prayerType);
  }
}