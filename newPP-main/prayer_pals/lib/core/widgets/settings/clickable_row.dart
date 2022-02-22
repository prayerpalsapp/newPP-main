import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class ClickableRow extends HookWidget {
  final String clickableText;
  final Function() clickPath;

  const ClickableRow({
    Key? key,
    required this.clickableText,
    required this.clickPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
        child: InkWell(
            child: Text(
              clickableText,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            onTap: (clickPath)),
      ),
    ]);
  }
}
