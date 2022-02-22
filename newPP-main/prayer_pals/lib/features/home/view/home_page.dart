import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/admob/admob_widget.dart';
import 'package:prayer_pals/core/iap/iap_handler.dart';
import 'package:prayer_pals/core/providers/ppcuser_core_provider.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/home_page_button_section.dart';
import 'package:prayer_pals/core/widgets/scripture_section.dart';
import 'package:prayer_pals/core/utils/constants.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IAPHandler.initPlatformState();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          StringConstants.home,
        ),
        leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.blue),
              onPressed: () {}),
        centerTitle: true,
        
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 4,
              ),
              Text(
                StringConstants.welcome,
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: SizeConfig.safeBlockVertical! * 8.5,
                  color: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 1.5,
              ),
              const Divider(),
              Card(
                  elevation: 5,
                  margin: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  color: Colors.lightBlue[50],
                  //shadowColor: Colors.black87,
                  child: const ScriptureSection()),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 6,
              ),
              const HomePageButtonSection(),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 3,
              ),
              FutureBuilder(
                  future: ref.read(ppcUserCoreProvider).hasUserRemovedAds(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      dynamic userHasRemovedAds = snapshot.data;
                      if (userHasRemovedAds == true) {
                        return Container();
                      } else {                   
                        return SizedBox(
                          width: SizeConfig.screenWidth! * .9,
                          height: 400,
                          child: const AdMobs(),
                        );
                      }
                    } else {
                      return Container(
                          width:SizeConfig.screenWidth! * .9,
                          child: const Image(image: AssetImage('assets/images/thank_you.jpg')));
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
