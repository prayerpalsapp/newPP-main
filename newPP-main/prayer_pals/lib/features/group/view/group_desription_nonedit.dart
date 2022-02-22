import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/ppc_message_dialog.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/core/widgets/toggle_widget.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';
import 'package:prayer_pals/core/utils/constants.dart';

//////////////////////////////////////////////////////////////////////////
//
//     This controls what the a group member or guest will see on the
//     group description page.
//
//////////////////////////////////////////////////////////////////////////

class GroupDescriptionNonEdit extends HookWidget {
  final String? groupName;
  final String? groupDescription;
  final GroupMember groupMember;
  final bool isGuest;

  const GroupDescriptionNonEdit(
      {Key? key,
      required this.groupName,
      required this.groupDescription,
      required this.groupMember,
      required this.isGuest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 8, 0),
            child: SizedBox(
              width: SizeConfig.safeBlockHorizontal! * 150,
              height: SizeConfig.safeBlockVertical! * 26,
              child: Text(
                groupDescription!,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical! * 2.5,
                  fontFamily: 'Helvetica',
                ),
              ),
            ),
          ),
        ),
        PPCstuff.divider,
        Visibility(
          visible: !isGuest,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                    child: Text(StringConstants.personalNotifications,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.safeBlockVertical! * 2.5,
                        )),
                  ),
                  SizedBox(
                    width: 180,
                    child: Column(
                      children: [
                        PPCToggleWidget(
                          title: StringConstants.app,
                          size: 2.5,
                          toggleState: groupMember.appNotify,
                          callback: (value) {},
                        ),
                        PPCToggleWidget(
                          title: StringConstants.text,
                          size: 2.5,
                          toggleState: groupMember.textNotify,
                          callback: (value) {},
                        ),
                        PPCToggleWidget(
                          title: StringConstants.email,
                          size: 2.5,
                          toggleState: groupMember.emailNotify,
                          callback: (value) {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: !isGuest,
          child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PPCstuff.divider,
                  const SizedBox(height: 20),
                  _buttonsSection(context),
                ],
              )),
        )
      ],
    );
  }

  Widget _buttonsSection(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: groupMember.isAdmin,
          child: PPCRoundedButton(
            title: StringConstants.groupMessage,
            buttonRatio: .8,
            buttonWidthRatio: 1,
            callback: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => PPCmessage(
                      context: context, title: StringConstants.groupMessage));
            },
            bgColor: Colors.lightBlueAccent.shade100,
            textColor: Colors.white,
          ),
          replacement: PPCRoundedButton(
            title: StringConstants.adminMessage,
            buttonRatio: .8,
            buttonWidthRatio: 1,
            callback: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => PPCmessage(
                      context: context, title: StringConstants.adminMessage));
            },
            bgColor: Colors.lightBlueAccent.shade100,
            textColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
