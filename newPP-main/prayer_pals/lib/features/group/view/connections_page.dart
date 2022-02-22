import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:prayer_pals/core/widgets/connections_button.dart';
import 'package:prayer_pals/core/widgets/header_section.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'my_groups_list.dart';
import 'lists_temporary_approach/my_pending_requests.dart';

//////////////////////////////////////////////////////////////////////////
//
//     the gateway to the group section. This will list all the Pending groups
//     that the user has requested and should also list groups the user has
//     been invited to. Have not programmed this. It should show an X to cancel
//     previous requests and give an option to accept or reject if user was invited
//     My goupd section list the groups that the user is a part of. If the user
//     is an admin, the text should be blue to indicate status. Two buttons are
//     at the bottom for joining a group, which goes to the search page and
//     start group, which should pop up an inApp purchase.
//
//////////////////////////////////////////////////////////////////////////

class ConnectionsPage extends HookWidget {
  const ConnectionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          StringConstants.connections,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: const [
          HeaderSection(title: StringConstants.pendingRequests),
          PendingRequests(),
          HeaderSection(title: StringConstants.myGroups),
          MyGroups(),
          ConnectionsButton(),
        ],
      ),
    );
  }
}
