import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/providers/pray_now_provider.dart';
import 'my_prayer_list.dart';

//TODO figure out how to get a value from firestore, add it to the variable,
// then save it back to firestore !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

class PrayNowPage extends HookConsumerWidget {
  const PrayNowPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime startTime = DateTime.now();
    bool isPrayNow = true;
    return Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          title: const Text(
            StringConstants.prayNow,
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () {
                ref.read(prayerNowProvider).updateTime(startTime);
                Navigator.of(context).pop();
              }),
          centerTitle: true,
        ),
        body:
            PrayerList(isPrayNow: isPrayNow, prayerType: PrayerType.myPrayers));
  }
}
