import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/providers/global_prayer_provider.dart';
import 'prayer_list_item.dart';

class GlobalPrayerList extends HookConsumerWidget {
  final PrayerType prayerType;

  const GlobalPrayerList(this.prayerType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalPrayerController = ref.watch(globalPrayerControllerProvider);
    return FutureBuilder<List<Prayer>>(
      future: globalPrayerController.retrievePrayers(prayerType),
      builder: (BuildContext context, AsyncSnapshot<List<Prayer>> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.requireData;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return PrayerListItem(
                prayer: data[index],
                prayerType: prayerType,
              );
            },
          );
        } else {}
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(StringConstants.loading),
          );
        } else {
          return const Center(
            child: Text(StringConstants.loading),
          );
        }
      },
    );
  }
}
