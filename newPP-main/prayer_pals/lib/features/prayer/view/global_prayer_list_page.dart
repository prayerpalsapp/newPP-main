import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/providers/global_prayer_provider.dart';
import 'global_prayer_list.dart';

class GlobalPrayersPage extends HookConsumerWidget {
  const GlobalPrayersPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalPrayerListController =
        ref.watch(globalPrayerControllerProvider);
    String _title;
    if (globalPrayerListController.prayerType == PrayerType.answered) {
      _title = StringConstants.answeredPrayer;
    } else {
      _title = StringConstants.prayerPals;
    }
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          _title,
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: globalPrayerListController.prayerType == PrayerType.answered,
            replacement: IconButton(
              icon: Icon(
                Icons.comment_outlined,
                color: Colors.white,
                size: SizeConfig.safeBlockHorizontal! * 8,
              ),
              onPressed: () {
                if (globalPrayerListController.prayerType! ==
                    PrayerType.global) {
                  globalPrayerListController.setPrayerType(PrayerType.answered);
                } else {
                  globalPrayerListController.setPrayerType(PrayerType.global);
                }
              },
            ),
            child: IconButton(
              icon: Icon(
                CupertinoIcons.chat_bubble_2,
                color: Colors.white,
                size: SizeConfig.safeBlockHorizontal! * 8,
              ),
              onPressed: () {
                if (globalPrayerListController.prayerType! ==
                    PrayerType.answered) {
                  globalPrayerListController.setPrayerType(PrayerType.global);
                } else {
                  globalPrayerListController.setPrayerType(PrayerType.answered);
                }
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                GlobalPrayerList(globalPrayerListController.prayerType!)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
