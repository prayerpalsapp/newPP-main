import 'dart:io';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
      // Test: ca-app-pub-3940256099942544/6300978111
      // Android id: ca-app-pub-6387992431790976/5306600488 - real ads
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
      // iOS id: ca-app-pub-6387992431790976~5867500933
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
