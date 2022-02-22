import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/providers/prayer_detail_provider.dart';

class AddRemovePrayerButton extends HookConsumerWidget {
  final Prayer prayer;

  const AddRemovePrayerButton({required this.prayer, Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future:
              ref.read(prayerDetailProvider).isPrayerInMyPersonalList(prayer),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Visibility(
                visible: snapshot.data! as bool,
                child: PPCRoundedButton(
                  title: StringConstants.remove,
                  buttonRatio: .9,
                  buttonWidthRatio: .9,
                  callback: () {
                    ref
                        .read(prayerDetailProvider)
                        .removePrayerFromMyList(prayer);
                  },
                  bgColor: Colors.lightBlueAccent.shade100,
                  textColor: Colors.white,
                ),
                replacement: PPCRoundedButton(
                  title: StringConstants.add,
                  buttonRatio: .9,
                  buttonWidthRatio: .9,
                  callback: () {
                    ref.read(prayerDetailProvider).addPrayerToMyList(prayer);
                  },
                  bgColor: Colors.lightBlueAccent.shade100,
                  textColor: Colors.white,
                ),
              );
            } else {
              return const Center(
                child: Text(StringConstants.loading),
              );
            }
          },
        ),
      ),
    );
  }
}
