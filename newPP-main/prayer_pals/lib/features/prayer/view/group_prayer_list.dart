import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/providers/group_prayer_provider.dart';
import 'prayer_list_item.dart';

class GroupPrayerList extends HookConsumerWidget {
  final String groupId;
  final String groupName;
  final PrayerType prayerType;

  const GroupPrayerList({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.prayerType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerList = ref
        .watch(groupPrayerControllerProvider)
        .retrievePrayers(groupId, prayerType);

    return FutureBuilder<List<Prayer>>(
        future: prayerList,
        builder: (BuildContext context, AsyncSnapshot<List<Prayer>> snapshot) {
          if (snapshot.hasError) {}
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading ..."),
            );
          } else {
            final data = snapshot.requireData;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return PrayerListItem(
                    prayer: data[index],
                    prayerType: prayerType,
                  );
                });
          }
        });
  }
}
