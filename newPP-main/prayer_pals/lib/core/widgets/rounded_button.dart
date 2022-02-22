import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/size_config.dart';

class PPCRoundedButton extends HookWidget {
  final String title;
  final double buttonRatio;
  final double buttonWidthRatio;
  final VoidCallback callback;
  final Color bgColor;
  final Color textColor;
  const PPCRoundedButton({
    Key? key,
    required this.title,
    required this.buttonRatio,
    required this.buttonWidthRatio,
    required this.callback,
    this.bgColor = Colors.white,
    this.textColor = Colors.lightBlueAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: Container(
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(
              SizeConfig.safeBlockVertical! * 4.5 * buttonRatio,
            )),
        height: SizeConfig.blockSizeVertical! * 8 * buttonRatio,
        width: MediaQuery.of(context).size.width * .8 * buttonWidthRatio,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: SizeConfig.blockSizeVertical! * 3.0 * buttonRatio,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
