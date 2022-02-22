import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final groupPrayerControllerProvider =
    Provider<IAPHandler>((ref) => IAPHandler());

class IAPHandler {
  static const String _kRemovedAdsId = 'com.prayerpals.removeads';
  static const String _kStartGroupId = 'com.prayerpals.startgroup';
  static List<Product>? products;

  static Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    if (Platform.isAndroid) {
      await Purchases.setup("goog_BwkDRwRCkattXcGffvBSnzdsGKE");
    } else if (Platform.isIOS) {
      await Purchases.setup("appl_pwDOkfMYeFilnAuaibMSARVeYrU");
    }
    fetchProducts();
  }

  static fetchProducts() async {
    if (products == null) {
      try {
        products =
            await Purchases.getProducts([_kRemovedAdsId, _kStartGroupId]);
      } on PlatformException catch (e) {
        debugPrint('Error fetching RevenueCat Products: ${e.toString()}');
      }
    }
  }

  static Future<bool> purchaseStartGroup() async {
    try {
      PurchaserInfo purchaseInfo =
          await Purchases.purchaseProduct(_kStartGroupId);
      debugPrint('Purchase start group success: $purchaseInfo');
      return true;
    } catch (e) {
      debugPrint('Purchase start group failure: ${e.toString()}');
      return false;
    }
  }

  static Future<bool> purchaseRemoveAds() async {
    try {
      PurchaserInfo purchaseInfo =
          await Purchases.purchaseProduct(_kRemovedAdsId);
      debugPrint('Purchase remove ads success: $purchaseInfo');
      return true;
    } catch (e) {
      debugPrint('Purchase remove ads failure: ${e.toString()}');
      return false;
    }
  }
}
