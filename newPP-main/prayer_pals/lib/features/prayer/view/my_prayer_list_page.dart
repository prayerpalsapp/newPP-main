import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/providers/my_prayer_list_page_provider.dart';
import 'my_prayer_list.dart';

class MyPrayersPage extends HookConsumerWidget {
  const MyPrayersPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myPrayerListProvider = ref.watch(myPrayerListPageProvider);
    String _title;
    if (myPrayerListProvider.prayerType == PrayerType.answered) {
      _title = StringConstants.answeredPrayer;
    } else {
      _title = StringConstants.myPrayers;
    }
    bool isPrayNow = false;
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          _title,
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: myPrayerListProvider.prayerType == PrayerType.answered,
            replacement: IconButton(
              icon: Icon(
                Icons.comment_outlined,
                color: Colors.white,
                size: SizeConfig.safeBlockHorizontal! * 8,
              ),
              onPressed: () {
                if (myPrayerListProvider.prayerType == PrayerType.answered) {
                  myPrayerListProvider.setPrayerType(PrayerType.myPrayers);
                } else {
                  myPrayerListProvider.setPrayerType(PrayerType.answered);
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
                if (myPrayerListProvider.prayerType == PrayerType.answered) {
                  myPrayerListProvider.setPrayerType(PrayerType.myPrayers);
                } else {
                  myPrayerListProvider.setPrayerType(PrayerType.answered);
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
                PrayerList(
                    isPrayNow: isPrayNow,
                    prayerType: myPrayerListProvider.prayerType!)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
