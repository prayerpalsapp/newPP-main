import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/size_config.dart';

class PrayNowDescriptionDialog extends HookWidget {
  final String title;
  final String description;

  const PrayNowDescriptionDialog(
      {Key? key, required this.title, required this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        overflow: TextOverflow.ellipsis,
      ),
      actions: [
        // action button
        IconButton(
          icon: Icon(
            Icons.close,
            size: SizeConfig.safeBlockHorizontal! * 8,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          }, //Change to Answered prayer
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Helvetica',
            ),
          )
        ],
      ),
    );
  }
}
