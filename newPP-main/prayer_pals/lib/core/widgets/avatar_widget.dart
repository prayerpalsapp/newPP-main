// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PPCAvatar extends HookWidget {
  final double radSize;
  final String image;
  String? networkImage;

  PPCAvatar({
    Key? key,
    required this.radSize,
    required this.image,
    this.networkImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasPicture = true; //change to passed in value

    if (hasPicture == true) {
      if (networkImage == null ||
          networkImage == image ||
          networkImage!.isEmpty) {
        return CircleAvatar(
            foregroundImage: AssetImage(image), radius: radSize);
      } else {
        return CircleAvatar(
            foregroundImage: NetworkImage(networkImage!), radius: radSize);
      }
    } else {
      return CircleAvatar(
        backgroundColor: Colors.grey.shade500,
        child: const Text(''),
        radius: radSize,
      );
    }
  }
}
