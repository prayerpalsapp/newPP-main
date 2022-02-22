import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/providers/reminder_provider.dart';

class ReminderRow extends HookWidget {
  final String clickableText;
  final ReminderController settingsProvider;
  const ReminderRow({
    Key? key,
    required this.clickableText,
    required this.settingsProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
          child: InkWell(
              child: Text(
                clickableText,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              onTap: () {
                if (settingsProvider.timeString != null &&
                    settingsProvider.timeString!.isNotEmpty &&
                    settingsProvider.timeString != "null") {
                  settingsProvider.cancelGeneralReminder();
                } else {
                  //General Reminder is id 001
                  settingsProvider.setReminder(context, 001);
                }
              }),
        ),
      ],
    );
  }
}
