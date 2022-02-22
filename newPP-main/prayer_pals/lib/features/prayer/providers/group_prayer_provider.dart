import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/repositories/group_prayer_repository.dart';

final groupPrayerControllerProvider =
    ChangeNotifierProvider<GroupPrayerController>(
        (ref) => GroupPrayerController(ref.read));

class GroupPrayerController extends ChangeNotifier {
  bool showAnswered = true;
  String previousType = "";
  String listType = "";
  final Reader _reader;
  PrayerType? prayerType;

  GroupPrayerController(this._reader) {
    prayerType = PrayerType.group;
  }

  Future<List<Prayer>> retrievePrayers(group, PrayerType prayerType) async {
    return await _reader(groupPrayerRepositoryProvider)
        .retrievePrayers(group, prayerType);
  }

  setShowAnswered(bool show) {
    showAnswered = show;
    Timer.run(() {
      notifyListeners();
    });
  }

  setPreviousType(String type) {
    previousType = type;
    Timer.run(() {
      notifyListeners();
    });
  }
  
  setListType(String type) {
    listType = type;
    Timer.run(() {
      notifyListeners();
    });
  }

  setPrayerType(PrayerType type) {
    prayerType = type;
    notify();
  }

  notify() {
    notifyListeners();
  }
}