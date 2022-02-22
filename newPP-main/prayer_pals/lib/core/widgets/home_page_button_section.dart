import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/home/providers/home_provider.dart';

class HomePageButtonSection extends HookConsumerWidget {
  const HomePageButtonSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        PPCRoundedButton(
          title: StringConstants.addPrayer,
          buttonRatio: 1,
          buttonWidthRatio: 1,
          callback: () {
            ref.read(homeControllerProvider).setIndex(2);
          },
          bgColor: Colors.lightBlueAccent.shade100,
          textColor: Colors.white,
        ),
        SizedBox(
          height: SizeConfig.safeBlockVertical! * 2,
        ),
        PPCRoundedButton(
          title: StringConstants.prayNow,
          buttonRatio: 1,
          buttonWidthRatio: 1,
          callback: () {
            Navigator.pushNamed(context, '/PrayNowPage');
          },
          bgColor: Colors.lightBlueAccent.shade100,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
