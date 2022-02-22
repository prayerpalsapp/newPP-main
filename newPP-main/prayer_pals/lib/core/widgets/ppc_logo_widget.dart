import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PPCLogoWidget extends HookWidget {
  final double size;

  const PPCLogoWidget({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: const Padding(
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Image(image: AssetImage('assets/images/logoBlueS.png')),
      ),
      radius: 8 * size,
      backgroundColor: Colors.white,
    );
  }
}
