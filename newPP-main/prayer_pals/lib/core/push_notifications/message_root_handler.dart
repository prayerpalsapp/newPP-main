// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/event_bus/group_subscribtion_event.dart';
import 'package:prayer_pals/core/event_bus/ppc_event_bus.dart';
import 'package:prayer_pals/features/home/view/home_page_container.dart';

class MessageRootHandler extends HookWidget {
  MessageRootHandler({Key? key}) : super(key: key);

  final PPCEventBus _eventBus = PPCEventBus();
  StreamSubscription? iosSubscription;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      {
        _configureFCM(context);
        _setupEventListeners();
      }
    }, []);
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: Material(
        child: HomePageContainer(),
      ),
    );
  }

  _configureFCM(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
        final creatorId = message.data['creatorId'];
        if (creatorId != FirebaseAuth.instance.currentUser!.uid) {
          final creatorDisplayname = message.data['creatorDisplayName'];
          ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
            content: Text(
                '\n\n${message.notification!.title!}\n$creatorDisplayname: ${message.notification!.body}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                )),
            leading: const Icon(Icons.info, color: Colors.white),
            backgroundColor: Colors.greenAccent,
            actions: [
              TextButton(
                  onPressed: () {},
                  child: const Text('Open',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ))),
              TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                  },
                  child: const Text('Dismiss',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ))),
            ],
          ));
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      analyzeIncomingPNString(
          message.data['type'], message.data['id'], message.data);
    });
  }

  _setupEventListeners() {
    _eventBus.on<SubscribeToGroupPNEvent>().listen((event) {
      fcmSubscribeToTopic(event.groupId, (success) => {});
    });
    _eventBus.on<UNSubscribeToGroupPNEvent>().listen((event) {
      fcmUnsubscribeFromTopic(event.groupId, (success) => {});
    });
  }

  analyzeIncomingPNString(
      String input, String id, Map<String, dynamic> message) {
    debugPrint(
        '\n\nRECEIVED PN: $input FOR ID: $id\n\n WITH MESSAGE: $message');
    switch (input) {
      default:
    }
  }

  static fcmSubscribeToTopic(
      String groupId, Function(bool success) successCallback) {
    FirebaseMessaging.instance
        .subscribeToTopic('$groupId-GroupCampaign_Created')
        .then((value) {
      debugPrint(
          'FCM - Successfully subscribed to topic: $groupId-GroupCampaign_Created');
      successCallback(true);
    }).catchError((error) {
      debugPrint('FCM - Error subscribing to topic: $groupId:\n****$error');
      successCallback(false);
    });
  }

  static fcmUnsubscribeFromTopic(
      String groupId, Function(bool success) successCallback) {
    FirebaseMessaging.instance
        .unsubscribeFromTopic('$groupId-GroupCampaign_Created')
        .then((value) {
      debugPrint(
          'FCM - Successfully UNSUBscribed from topic: $groupId-GroupCampaign_Created');
      successCallback(true);
    }).catchError((error) {
      debugPrint('FCM - Error unsubscribing from topic: $groupId:\n****$error');
      successCallback(false);
    });
  }
}
