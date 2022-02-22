import 'package:flutter/material.dart';
import 'package:prayer_pals/core/utils/size_config.dart';

class PPCToggleWidget extends StatefulWidget {
  final String title;
  final double size;
  final bool toggleState;
  final Function(bool value) callback;
  const PPCToggleWidget({
    Key? key,
    required this.title,
    required this.size,
    required this.toggleState,
    required this.callback,
  }) : super(key: key);

  @override
  _PPCToggleWidgetState createState() => _PPCToggleWidgetState();
}

class _PPCToggleWidgetState extends State<PPCToggleWidget> {
  bool? switchValue = false;

  @override
  initState() {
    super.initState();
    switchValue = widget.toggleState;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: SizeConfig.safeBlockHorizontal! * 2,
        right: SizeConfig.safeBlockHorizontal! * 2,
        top: SizeConfig.safeBlockHorizontal! * 1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Helvetica',
              fontSize: SizeConfig.safeBlockVertical! * widget.size,
            ),
          ),
          Switch(
            value: switchValue!,
            onChanged: (value) {
              widget.callback(value);
              setState(() {
                switchValue = value;
              });
            },
            activeTrackColor: Colors.lightBlueAccent,
            activeColor: Colors.lightBlue,
          ),
        ],
      ),
    );
  }
}
