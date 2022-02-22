import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/services/notification_service.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final reminderControllerProvider = ChangeNotifierProvider<ReminderController>(
  (ref) => ReminderController(
    ref.read,
    NotificationService(),
  ),
);

class ReminderController extends ChangeNotifier {
  final Reader reader;
  String? timeString = '';
  final NotificationService _notificationService;

  ReminderController(this.reader, this._notificationService) : super() {
    getTimeString();
  }

  getTimeString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    timeString = prefs.getString('timeString');
    notifyListeners();
  }

  void setReminder(BuildContext context, int id) async {
    final timeString = await _notificationService.scheduleNotifications(
      context,
      id,
      StringConstants.prayerPals,
      StringConstants.justAFriendlyReminder,
    );
    if (timeString.isNotEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('timeString', timeString);
      getTimeString();
    }
  }

  void cancelGeneralReminder() async {
    await _notificationService.cancelNotifications(001);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('timeString', 'null');
    getTimeString();
  }

  Future<void> setReminderForPrayer(BuildContext context, Prayer prayer) async {
    String stringId = prayer.uid.replaceAll(RegExp('\\D'), '').substring(1, 4);
    int id = int.parse(stringId);
    final timeString = await _notificationService.scheduleNotifications(
      context,
      id,
      StringConstants.prayerReminder,
      '${prayer.creatorDisplayName}: ${prayer.title}\n${prayer.description}',
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(stringId, timeString);
    debugPrint(
        'Prayer: ${prayer.description} by ${prayer.creatorDisplayName} set for daily reminder: $timeString');
    notifyListeners();
  }

  Future<String> getReminderForPrayer(Prayer prayer) async {
    String stringId = prayer.uid.replaceAll(RegExp('\\D'), '').substring(1, 4);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final prayerString = prefs.getString(stringId);
    if (prayerString != null && prayerString != 'null') {
      return prayerString;
    } else {
      return '';
    }
  }

  deleteReminderForPrayer(Prayer prayer) async {
    String stringId = prayer.uid.replaceAll(RegExp('\\D'), '').substring(1, 4);
    int id = int.parse(stringId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _notificationService.cancelNotifications(id);
    prefs.remove(stringId);
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
