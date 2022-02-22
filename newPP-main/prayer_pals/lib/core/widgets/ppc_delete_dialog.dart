import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';

Future<void> showPPCDeleteDialog(
    BuildContext context, Prayer prayer, VoidCallback callback) async {
  String bodyText = StringConstants.areYouSureYouWishToDeleteYourPrayer;
  if (prayer.isGlobal &&
      prayer.creatorUID != FirebaseAuth.instance.currentUser!.uid) {
    bodyText = StringConstants
        .areYouSureYouWishToRemoveThisGlobalPrayerFromYourPrayerList;
  }
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(StringConstants.prayerPals),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                bodyText,
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
            onPressed: () {
              callback();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
