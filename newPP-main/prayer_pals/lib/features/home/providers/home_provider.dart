import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/view/connections_page.dart';
import 'package:prayer_pals/features/home/view/home_page.dart';
import 'package:prayer_pals/features/prayer/view/create_prayer_page.dart';
import 'package:prayer_pals/features/prayer/view/global_prayer_list_page.dart';
import 'package:prayer_pals/features/prayer/view/my_prayer_list_page.dart';
import 'package:prayer_pals/features/user/view/settings_page.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

final homeControllerProvider =
    ChangeNotifierProvider.autoDispose<HomeController>(
        (ref) => HomeController(ref.read));

class HomeController extends ChangeNotifier {
  static const HomePage _homePage = HomePage();
  static const MyPrayersPage _prayersPage = MyPrayersPage();
  static final CreatePrayerPage _createPrayerPage = CreatePrayerPage(
    prayerType: PrayerType.myPrayers,
  );
  static const GlobalPrayersPage _globalPrayersPage = GlobalPrayersPage();
  static const ConnectionsPage _connectionsPage = ConnectionsPage();
  static final SettingsPage _settingsPage = SettingsPage();

  //late BannerAd _bannerAd;
  //bool _isBannerAdReady = false;

  List<Widget> screens = [
    _homePage,
    _prayersPage,
    _createPrayerPage,
    _globalPrayersPage,
    _connectionsPage,
    _settingsPage,
  ];

  final Reader reader;
  int selectedIndex = 0;

  HomeController(this.reader);

  // Scripture fetchDailyScripture() {
  //  return reader(homeRepositoryProvider).getTodaysScripture();
  //}
  setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
