import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';

final myPrayerListPageProvider = ChangeNotifierProvider<MyPrayerListPageController>(
    (ref) => MyPrayerListPageController(ref.read, PrayerType.myPrayers));

class MyPrayerListPageController extends ChangeNotifier {
  final Reader read;
  PrayerType? prayerType;
  MyPrayerListPageController(this.read, this.prayerType);

  setPrayerType(PrayerType type) {
    prayerType = type;
    notifyListeners();
  }
}
