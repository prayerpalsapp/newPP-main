import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/features/home/providers/home_provider.dart';

class HomePageContainer extends ConsumerWidget {
  const HomePageContainer({Key? key}) : super(key: key);

  void _onItemTapped(WidgetRef ref, int index, BuildContext context) {
    //Navigator.of(context).pushNamed('/nextscreen');   //Attempt to use back button on Android phones
    ref.read(homeControllerProvider).setIndex(index);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SizeConfig().init(context);

    final _homeController = ref.watch(homeControllerProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        selectedItemColor: Colors.lightBlue[200],
        unselectedItemColor: Colors.grey[700],
        currentIndex: _homeController.selectedIndex, //New
        onTap: (index) {
          _onItemTapped(ref, index, context);
        },

        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'My Prayers',
            icon: Icon(CupertinoIcons.chat_bubble_2),
          ),
          BottomNavigationBarItem(
            label: 'Add Prayer',
            icon: Icon(Icons.add),
          ),
          BottomNavigationBarItem(
            label: 'Global',
            icon: Icon(CupertinoIcons.globe),
          ),
          BottomNavigationBarItem(
            label: 'Connections',
            icon: Icon(CupertinoIcons.group),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Center(
        child: _homeController.screens.elementAt(_homeController.selectedIndex),
      ),
    );
  }
}
