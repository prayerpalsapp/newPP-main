import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/widgets/avatar_widget.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/group/providers/group_provider.dart';
import 'package:prayer_pals/features/prayer/view/group_prayer_list_page.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'group_description_page.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Makes a list of all the groups user is in - this is a duplicate
//     collection from groups and is not efficient or good to have
//     duplicate data, but it is controlled through clients file so data
//     integrity is maintained.
//
//////////////////////////////////////////////////////////////////////////

class MyGroups extends HookConsumerWidget {
  const MyGroups({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupProvider = ref.watch(groupControllerProvider);
    return StreamBuilder<QuerySnapshot>(
      stream: groupProvider.fetchMyGroups(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text(StringConstants.loading),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.requireData;
          return Expanded(
            child: ListView.builder(
              itemCount: data.size,
              itemBuilder: (context, index) {
                Group group = Group.fromQuerySnapshot(data, index);
                return Visibility(
                  visible: true,
                  child: Card(
                    margin: const EdgeInsets.all(1),
                    child: ListTile(
                      leading: PPCAvatar(
                        radSize: 15,
                        image: StringConstants.groupIcon,
                        networkImage: group.groupImageURL,
                      ),
                      trailing: IconButton(
                        icon: const Icon(CupertinoIcons.chat_bubble_2),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroupPrayersPage(
                                groupId: group.groupUID,
                                groupName: group.groupName,
                              ),
                            ),
                          );
                        },
                      ),
                      title: Text(
                        group.groupName,
                        style: const TextStyle(
                          color: Colors.lightBlue,
                        ),
                      ),
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GroupDescriptionPage(
                              groupUID: group.groupUID,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
