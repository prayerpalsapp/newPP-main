import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/avatar_widget.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';

class PrayerListItemHeaderRow extends HookWidget {
  final Prayer prayer;

  const PrayerListItemHeaderRow({Key? key, required this.prayer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                PPCAvatar(
                  radSize: 20,
                  image: StringConstants.userIcon,
                  networkImage:
                      prayer.creatorImageURL ?? StringConstants.userIcon,
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal! * 2,
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal! * 45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prayer.creatorDisplayName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical! * 2.5,
                        ),
                      ),
                      Text(
                        prayer.title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: SizeConfig.safeBlockVertical! * 0.2,
                          fontSize: SizeConfig.safeBlockVertical! * 2.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${prayer.dateCreated.substring(1, 10)}\n${prayer.dateCreated.substring(11, prayer.dateCreated.length)}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: SizeConfig.safeBlockVertical! * 2.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
