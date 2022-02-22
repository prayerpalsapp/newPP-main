import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HeaderSection extends HookWidget {
  final String title;
  const HeaderSection({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 10, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontFamily: 'Helvetica',
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
