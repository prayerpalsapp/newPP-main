import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/widgets/pray_now_widget.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/providers/my_prayer_provider.dart';
import 'prayer_list_item.dart';

// ignore: must_be_immutable
class PrayerList extends HookConsumerWidget {
  final bool isPrayNow;
  final PrayerType prayerType;
  List checkedIndexes = [];

  PrayerList({Key? key, required this.isPrayNow, required this.prayerType})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerProvider = ref.watch(prayerControllerProvider);
    return FutureBuilder<List<Prayer>>(
      future: prayerProvider.retrievePrayers(prayerType),
      builder: (BuildContext context, AsyncSnapshot<List<Prayer>> snapshot) {
        if (snapshot.hasError) {}
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(StringConstants.loading),
          );
        } else {
          final data = snapshot.requireData;
          if (isPrayNow == true) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: PrayNowRow(
                        title: data[index].title,
                        description: data[index].description,
                        isSelected: checkedIndexes.contains(index),
                        callback: () {
                          if (!checkedIndexes.contains(index)) {
                            checkedIndexes.add(index);
                          } else {
                            checkedIndexes.remove(index);
                          }
                        },
                      ),
                    );
                  }),
            );
          } else {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return PrayerListItem(
                  prayer: data[index],
                  prayerType: prayerType,
                );
              },
            );
          }
        }
      },
    );
  }
}
