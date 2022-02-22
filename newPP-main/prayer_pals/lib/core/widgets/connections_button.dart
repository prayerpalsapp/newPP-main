import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/group/providers/group_provider.dart';

class ConnectionsButton extends HookConsumerWidget {
  const ConnectionsButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PPCRoundedButton(
            title: StringConstants.joinGroup,
            buttonRatio: .6,
            buttonWidthRatio: .5,
            callback: () {
              Navigator.pushNamed(context, '/GroupSearchPage');
            },
            bgColor: Colors.lightBlueAccent.shade100,
            textColor: Colors.white,
          ),
          PPCRoundedButton(
            title: StringConstants.startGroup,
            buttonRatio: .6,
            buttonWidthRatio: .5,
            callback: () {
              bool isCreating = true;
              ref
                  .read(groupControllerProvider)
                  .checkForGroupCreationCredit(context, isCreating);
            },
            bgColor: Colors.lightBlueAccent.shade100,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
