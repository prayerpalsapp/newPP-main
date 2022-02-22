import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/providers/prayer_detail_provider.dart';

class ReportButton extends HookConsumerWidget {
  final Prayer prayer;
  const ReportButton({
    Key? key,
    required this.prayer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PPCRoundedButton(
          title: StringConstants.report,
          buttonRatio: .9,
          buttonWidthRatio: .9,
          callback: () {
            showDialogForReport(context, ref);
          },
          bgColor: Colors.lightBlueAccent.shade100,
          textColor: Colors.white,
        ),
      ),
    );
  }

  showDialogForReport(BuildContext context, WidgetRef ref) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(StringConstants.prayerPals),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  StringConstants.reporthingThisPrayer,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(StringConstants.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(StringConstants.okCaps),
              onPressed: () async {
                await ref.read(prayerDetailProvider).reportPrayer(prayer);

                Navigator.of(context).pop();
                showPPCDialog(context, StringConstants.prayerPals,
                    StringConstants.prayerReported, () {});
              },
            ),
          ],
        );
      },
    );
  }
}
