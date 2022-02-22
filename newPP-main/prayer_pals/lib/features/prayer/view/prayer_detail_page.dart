import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/add_remove_prayer_button.dart';
import 'package:prayer_pals/core/widgets/avatar_widget.dart';
import 'package:prayer_pals/core/widgets/report_button.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/prayer/providers/prayer_detail_provider.dart';

class PrayerDetailPage extends HookConsumerWidget {
  final Prayer prayer;
  const PrayerDetailPage({required this.prayer, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(prayerDetailProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          prayer.isGlobal == true
              ? StringConstants.prayerPals
              : prayer.groups[0].groupName,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ref
            .read(prayerDetailProvider)
            .fetchPrayer(prayer.uid, prayer.isGlobal),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: SizeConfig.blockSizeVertical! * 68,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(
                        SizeConfig.safeBlockVertical! * 2,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              PPCAvatar(
                                  radSize: 30, image: StringConstants.userIcon),
                              SizedBox(
                                width: SizeConfig.safeBlockHorizontal! * 2,
                              ),
                              SizedBox(
                                width: SizeConfig.screenWidth! * .7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      prayer.creatorDisplayName,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockVertical! * 2.5,
                                      ),
                                    ),
                                    Text(
                                      prayer.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            SizeConfig.safeBlockVertical! * 2.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical! * 2,
                          ),
                          Divider(
                            height: SizeConfig.safeBlockVertical! * 2,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            height: SizeConfig.safeBlockVertical! * 2,
                          ),
                          SizedBox(
                            width: SizeConfig.screenWidth! * .9,
                            child: Text(
                              prayer.description,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize:
                                      SizeConfig.safeBlockVertical! * 2.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AddRemovePrayerButton(
                  prayer: prayer,
                ),
                ReportButton(
                  prayer: prayer,
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(StringConstants.loading),
            );
          }
        },
      ),
    );
  }
}
