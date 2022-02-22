import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/prayer_list_item_bottom_row.dart';
import 'package:prayer_pals/core/widgets/prayer_list_item_detail_row.dart';
import 'package:prayer_pals/core/widgets/prayer_list_item_header_row.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'create_prayer_page.dart';
import 'prayer_detail_page.dart';

class PrayerListItem extends HookWidget {
  final Prayer prayer;
  final PrayerType prayerType;
  final VoidCallback? callback;

  const PrayerListItem({
    Key? key,
    required this.prayer,
    required this.prayerType,
    this.callback,
  }) : super(key: key);
//TODO: remove add to my prayers button when it's your prayer. If you go to global, tap on your prayer, it says add to my prayer
  @override
  Widget build(BuildContext context) {
    String? _uid = FirebaseAuth.instance.currentUser!.uid;
    bool _isOwner;
    _uid == prayer.creatorUID ? _isOwner = true : _isOwner = false;
    return InkWell(
      child: Card(
        clipBehavior: Clip.antiAlias,
        margin: EdgeInsets.only(
          top: SizeConfig.blockSizeVertical! * 1.5,
          left: SizeConfig.blockSizeHorizontal! * 2,
          right: SizeConfig.blockSizeHorizontal! * 2,
        ),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              PrayerListItemHeaderRow(prayer: prayer),
              PrayerListItemDetailRow(description: prayer.description),
              SizedBox(
                height: SizeConfig.safeBlockVertical! * 1,
              ),
              PrayerListItemBottomRow(
                null,
                prayer: prayer,
                isOwner: _isOwner,
                prayerType: prayerType,
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        if (_isOwner == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatePrayerPage(
                  prayer: prayer,
                  prayerType: prayerType,
                ),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PrayerDetailPage(
                        prayer: prayer,
                      ),
                  settings: RouteSettings(arguments: prayer)));
        }
      },
    );
  }
}
