import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'create_group_member.dart';
import 'invite_group_member.dart';
import 'lists_temporary_approach/group_member_list.dart';
import 'lists_temporary_approach/group_pending_requests.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Admin member management page. Shows pending requests to approve or deny
//     potential members. Lists members section. Each member is on a list tile
//     the first icon is blue if they are an admin or grey if they are not.
//     Then the user avatar and name is displayed. If they are a created member
//     (isCreated = true), then the admin can edit the member (not programmed yet)
//     the delete icon is used at the end to remove them from the group.
//     at the bottom fo the page, you can create a member (someone who doesn't
//     have the app), or invite to the group.
//
//////////////////////////////////////////////////////////////////////////

class AdminMembersPage extends StatefulWidget {
  const AdminMembersPage({Key? key}) : super(key: key);

  @override
  _AdminMembersPageState createState() => _AdminMembersPageState();
}

class _AdminMembersPageState extends State<AdminMembersPage> {
  @override
  Widget build(BuildContext context) {
    final group = ModalRoute.of(context)!.settings.arguments as Group;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.members,
        ),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _headerSection(context, StringConstants.pendingRequests),
          GroupPendingRequests(group: group),
          _headerSection(context, StringConstants.members),
          GroupMembers(group: group),
          const SizedBox(height: 15),
          // _buttonsSection(context, group),
        ],
      ),
    );
  }

  Widget _headerSection(BuildContext context, _title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 10, 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title,
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

  Widget _buttonsSection(BuildContext context, group) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        PPCRoundedButton(
          title: StringConstants.createMember,
          buttonRatio: .6,
          buttonWidthRatio: .5,
          callback: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    CreateGroupMemberWidget(group: group));
          },
          bgColor: Colors.lightBlueAccent.shade100,
          textColor: Colors.white,
        ),
        PPCRoundedButton(
          title: StringConstants.invite,
          buttonRatio: .6,
          buttonWidthRatio: .5,
          callback: () {
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    InviteGroupMemberWidget(group: group));
          },
          bgColor: Colors.lightBlueAccent.shade100,
          textColor: Colors.white,
        ),
      ],
    );
  }
}
