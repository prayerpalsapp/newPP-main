// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/event_bus/group_subscribtion_event.dart';
import 'package:prayer_pals/core/event_bus/ppc_event_bus.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/avatar_widget.dart';
import 'package:prayer_pals/core/widgets/edit_group_name_dialog.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/core/widgets/update_profile_pic.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';
import 'package:prayer_pals/features/group/providers/group_provider.dart';
import 'package:prayer_pals/features/group/providers/search_groups_provider.dart';
import 'package:prayer_pals/features/prayer/view/group_prayer_list_page.dart';
import 'admin_members_page.dart';

//////////////////////////////////////////////////////////////////////////
//
//     This controls what the user sees on the grouo description page when
//     is Admin = true. It allows them to see the edit pencil and the label
//     on the button changes depending on admin or member status. I am not 100%
//     happy with the functionality of the pencil and editing. I would like it
//     to be smoother and more intuative. I colored the word members if you
//     are admin becuase you tap on "members" to get to the admin members
//     section. Need to think about a better way of doing this.
//
//////////////////////////////////////////////////////////////////////////

class GroupDescriptionPage extends HookConsumerWidget {
  final TextEditingController _descriptionController = TextEditingController();
  final String groupUID;
  bool isSwitchedApp = true; //will come from user data
  bool isSwitchedText = true; //will come from user data
  bool isSwitchedEmail = true; //will come from user data
  Group? group;
  GroupController? groupProvider;

  GroupDescriptionPage({Key? key, required this.groupUID}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupProvider = ref.watch(groupControllerProvider);

    return FutureBuilder(
      future: groupProvider.fetchGroup(groupUID),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          group = snapshot.data as Group;
          if (group!.description != null && group!.description!.isNotEmpty) {
            _descriptionController.text = group!.description!;
          }

          final userIsAdmin =
              group!.creatorUID == FirebaseAuth.instance.currentUser!.uid;
          return Scaffold(
            appBar: AppBar(
              title: Text(group!.groupName),
              centerTitle: true,
              leading: IconButton(
                icon: Visibility(
                  visible: !groupProvider.isEdit,
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white),
                  replacement: Icon(Icons.edit, color: Colors.white),
                ),
                onPressed: () {
                  if (groupProvider.isEdit == false) {
                    Navigator.of(context).pop();
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          EditGroupNameDialog(groupName: group!.groupName),
                    );
                  }
                },
              ),
              actions: [
                Consumer(builder: (ctx, ref, widget) {
                  return IconButton(
                      icon: Visibility(
                        visible: groupProvider.isEdit,
                        child: Icon(CupertinoIcons.floppy_disk,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        if (_descriptionController.text != group!.description) {
                          groupProvider.saveDescriptionForGroup(
                              _descriptionController.text, groupUID);
                        }
                      });
                }),
                Visibility(
                  visible: userIsAdmin,
                  child: IconButton(
                    icon: Visibility(
                      visible: !groupProvider.isEdit,
                      child: const Icon(Icons.edit, color: Colors.white),
                      replacement: const Icon(Icons.clear, color: Colors.white),
                    ),
                    onPressed: () {
                      groupProvider.isEdit == true
                          ? groupProvider.setIsEdit(false)
                          : groupProvider.setIsEdit(true);
                    },
                  ),
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Row(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
                      child: Visibility(
                        visible: userIsAdmin,
                        child: InkWell(
                          child: PPCAvatar(
                            radSize: 25,
                            image: StringConstants.groupIcon,
                            networkImage: group!.groupImageURL,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => UpdatePicture(
                                context: context,
                                callback: (imageFile) async {
                                  await groupProvider.updateGroupImage(
                                      context, imageFile, group!);
                                  group =
                                      await groupProvider.fetchGroup(groupUID);
                                },
                              ),
                            );
                          },
                        ),
                        replacement: PPCAvatar(
                          radSize: 25,
                          image: StringConstants.groupIcon,
                          networkImage: group!.groupImageURL,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 15,
                    ),
                    Column(
                      children: [
                        Row(children: [
                          Container(
                            width: SizeConfig.safeBlockHorizontal! * 20,
                            alignment: Alignment.centerRight,
                            child: Visibility(
                              visible: userIsAdmin,
                              child: InkWell(
                                  child: Text(StringConstants.members,
                                      style: TextStyle(
                                        color: userIsAdmin == true
                                            ? Colors.lightBlue
                                            : Colors.black,
                                        fontSize:
                                            SizeConfig.safeBlockVertical! * 2,
                                        height:
                                            SizeConfig.safeBlockVertical! * .2,
                                      )),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminMembersPage(),
                                            settings: RouteSettings(
                                                arguments: group)));
                                  }),
                              replacement: Text(StringConstants.members,
                                  style: TextStyle(
                                    color: userIsAdmin == true
                                        ? Colors.lightBlue
                                        : Colors.black,
                                    fontSize: SizeConfig.safeBlockVertical! * 2,
                                    height: SizeConfig.safeBlockVertical! * .2,
                                  )),
                            ),
                          ),
                          SizedBox(width: SizeConfig.safeBlockHorizontal! * 4),
                          Container(
                            width: SizeConfig.safeBlockHorizontal! * 20,
                            alignment: Alignment.centerLeft,
                            child: Text(group!.memberCount.toString(),
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical! * 2,
                                  height: SizeConfig.safeBlockVertical! * .2,
                                )),
                          ),
                        ]),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GroupPrayersPage(
                                  groupId: group!.groupUID,
                                  groupName: group!.groupName,
                                ),
                              ),
                            );
                          },
                          child: Row(children: [
                            Container(
                              width: SizeConfig.safeBlockHorizontal! * 20,
                              alignment: Alignment.centerRight,
                              child: Text(
                                StringConstants.prayers,
                                style: TextStyle(
                                  fontSize: SizeConfig.safeBlockVertical! * 2,
                                  height: SizeConfig.safeBlockVertical! * .2,
                                  color: userIsAdmin == true
                                      ? Colors.lightBlue
                                      : Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(
                                width: SizeConfig.safeBlockHorizontal! * 4),
                            Container(
                              width: SizeConfig.safeBlockHorizontal! * 20,
                              alignment: Alignment.centerLeft,
                              child: Text(group!.prayerCount.toString(),
                                  style: TextStyle(
                                    fontSize: SizeConfig.safeBlockVertical! * 2,
                                    height: SizeConfig.safeBlockVertical! * .2,
                                  )),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    SizedBox(width: SizeConfig.safeBlockHorizontal! * 15)
                  ]),
                ),
                PPCstuff.divider,
                _descriptionForGroup(groupProvider),
                Spacer(),
                if (!userIsAdmin)
                  FutureBuilder(
                      future: groupProvider.amIAMemberOfThisGroup(groupUID),
                      builder: (context, memberSnap) {
                        if (memberSnap.hasData) {
                          final userIsMember = memberSnap.data;
                          if (userIsMember == true) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: PPCRoundedButton(
                                title: StringConstants.leaveGroup,
                                buttonRatio: .8,
                                buttonWidthRatio: .8,
                                callback: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text(
                                        StringConstants.prayerPals,
                                      ),
                                      content: Text(
                                        StringConstants
                                            .areYouSureYouWishToLeaveThisGroup,
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                          onPressed: () async {
                                            _leaveGroup(context, ref, group!);
                                          },
                                          child: const Text(
                                              StringConstants.okCaps),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                              StringConstants.cancel),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                bgColor: Colors.lightBlueAccent.shade100,
                                textColor: Colors.white,
                              ),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: PPCRoundedButton(
                                title: StringConstants.joinGroup,
                                buttonRatio: .8,
                                buttonWidthRatio: .8,
                                callback: () {
                                  _joinGroup(context, ref, group!);
                                },
                                bgColor: Colors.lightBlueAccent.shade100,
                                textColor: Colors.white,
                              ),
                            );
                          }
                        } else {
                          return Container();
                        }
                      }),
                if (userIsAdmin)
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: PPCRoundedButton(
                      title: StringConstants.deleteGroup,
                      buttonRatio: .8,
                      buttonWidthRatio: .8,
                      callback: () async {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              StringConstants.prayerPals,
                            ),
                            content: Text(
                              StringConstants
                                  .areYouSureYouWishToDeleteThisGroup,
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                onPressed: () async {
                                  await groupProvider.deleteGroup(group!);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text(StringConstants.okCaps),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(StringConstants.cancel),
                              ),
                            ],
                          ),
                        );
                      },
                      bgColor: Colors.lightBlueAccent.shade100,
                      textColor: Colors.white,
                    ),
                  ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: const Center(
              child: Text(StringConstants.loading),
            ),
          );
        }
      },
    );
  }

  _descriptionForGroup(GroupController grpProvider) {
    if (grpProvider.isEdit) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          controller: _descriptionController,
          enabled: group!.creatorUID == FirebaseAuth.instance.currentUser!.uid,
          maxLines: null,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintStyle: TextStyle(fontSize: 17, color: Colors.grey[400]),
            hintText: 'Enter Group Description',
          ),
        ),
      );
    } else if (group!.description != null && group!.description!.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: TextFormField(
          controller: _descriptionController,
          enabled: false,
          maxLines: null,
          cursorColor: Colors.black,
        ),
      );
    } else {
      return Container();
    }
  }

  _joinGroup(BuildContext ctx, WidgetRef ref, Group group) async {
    String srvMsg =
        await ref.read(searchGroupControllerProvider).joinGroup(group);
    if (srvMsg == StringConstants.success) {
      PPCEventBus eventBus = PPCEventBus();
      eventBus.fire(SubscribeToGroupPNEvent(groupId: group.groupUID));
      Navigator.of(ctx).pop();
    } else {
      showPPCDialog(ctx, StringConstants.almostThere, srvMsg, null);
    }
  }

  _leaveGroup(BuildContext ctx, WidgetRef ref, Group group) async {
    String srvMsg = await ref
        .read(groupMemberControllerProvider)
        .leaveGroup(group.groupUID);
    if (srvMsg == StringConstants.success) {
      PPCEventBus eventBus = PPCEventBus();
      eventBus.fire(UNSubscribeToGroupPNEvent(groupId: group.groupUID));
      Navigator.of(ctx).pop();
      Navigator.of(ctx).pop();
    } else {
      showPPCDialog(ctx, StringConstants.almostThere, srvMsg, null);
    }
  }
}
