import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/push_notifications/message_root_handler.dart';

import 'features/group/view/admin_members_page.dart';
import 'features/group/view/group_search_page.dart';
import 'features/home/view/home_page.dart';
import 'features/prayer/view/pray_now_page.dart';
import 'features/user/providers/auth_providers.dart';
import 'features/user/view/login_page.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);
    return MaterialApp(
      routes: {
        '/LoginPage': (context) => LoginPage(),
        '/HomePage': (context) => const HomePage(),
        '/PrayNowPage': (context) => const PrayNowPage(),
        '/GroupSearchPage': (context) => GroupSearchPage(),
        '/AdminMembersPage': (context) => const AdminMembersPage(),
        // '/Activity': (context) => Activity(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue[200],
        backgroundColor: Colors.white,
        fontFamily: 'OpenSans',
        hintColor: Colors.white,
        appBarTheme: const AppBarTheme(
          textTheme: TextTheme(
              headline6:
                  TextStyle(height: 2.0, fontSize: 30.0, color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: _authState.when(data: (data) {
        if (data != null) {
          return MessageRootHandler();
        }
        return LoginPage();
      }, loading: () {
        return const Scaffold(
          body: CircularProgressIndicator(),
        );
      }, error: (Object error, trace) {
        return LoginPage();
      }),
    );
  }
}
