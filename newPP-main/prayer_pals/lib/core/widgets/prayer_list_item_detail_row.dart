import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/size_config.dart';

class PrayerListItemDetailRow extends HookWidget {
  final String description;
  const PrayerListItemDetailRow({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      width: SizeConfig.screenWidth,
      child: Text(description,
          textAlign: TextAlign.left,
          maxLines: 2,
          overflow: TextOverflow.ellipsis),
    );
  }
}
