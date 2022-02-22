import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/core/utils/constants.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Used for sending a group invite to a user. Not sure how to do this
//     efficiently. currently, the email address is requested. Then I will
//     need to evaluate all users to find their uid, then add them to the
//     isPending list. It seems like this will take some time to do, but
//     it can be done in the background if done properly
//
//////////////////////////////////////////////////////////////////////////

class InviteGroupMemberWidget extends StatefulWidget {
  final Group group;

  const InviteGroupMemberWidget({Key? key, context, required this.group})
      : super(key: key);

  @override
  _InviteGroupMemberWidgetState createState() =>
      _InviteGroupMemberWidgetState();
}

class _InviteGroupMemberWidgetState extends State<InviteGroupMemberWidget> {
  final TextEditingController _emailAddressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        StringConstants.inviteToGroup,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            style: const TextStyle(
              fontFamily: 'Helvetica',
            ),
            textInputAction: TextInputAction.done,
            controller: _emailAddressController,
            decoration: const InputDecoration(
              hintText: StringConstants.emailAddress,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            _sendInvitation(context);
          },
          child: const Text(StringConstants.send),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(StringConstants.cancel),
        ),
      ],
    );
  }

  _sendInvitation(context) {
// Send invitation will add them to the group with the isPending value true
// they will show up in the group "Pending Requests" section and will show
// up on the connections page of the user under pending requests.
// Need to also add logic to make sure valid email and email is not used.
  }
}
