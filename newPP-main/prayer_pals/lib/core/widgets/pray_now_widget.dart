// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/pray_now_description_dialog.dart';

class PrayNowRow extends StatefulWidget {
  final String title;
  final String description;
  bool isSelected;
  final VoidCallback callback;

  PrayNowRow({
    Key? key,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.callback,
  }) : super(key: key);

  @override
  _PrayNowRowState createState() => _PrayNowRowState();
}

class _PrayNowRowState extends State<PrayNowRow> {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.blue),
      child: CheckboxListTile(
        value: widget.isSelected,
        onChanged: (value) {
          setState(() {
            widget.isSelected = !widget.isSelected;
            widget.callback();
            if (widget.isSelected == true) {
              showDialog(
                builder: (BuildContext context) => PrayNowDescriptionDialog(
                    title: widget.title, description: widget.description),
                context: context,
              );
            }
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: SizeConfig.safeBlockVertical! * 3.5,
            fontFamily: 'Helvetica',
            color: Colors.lightBlue,
          ),
        ),
        activeColor: Colors.lightBlue,
        checkColor: Colors.white,
      ),
    );
  }
}
