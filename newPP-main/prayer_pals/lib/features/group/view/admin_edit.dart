import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/rounded_button.dart';
import 'package:prayer_pals/core/utils/constants.dart';

//////////////////////////////////////////////////////////////////////////
//
//     This is a subpage of group description page where the admin can
//     edit the description. It also changes what the Admin sees based
//     on isAdmin.
//
//////////////////////////////////////////////////////////////////////////

class AdminEdit extends StatefulWidget {
  final String? groupName;
  final String? groupDescription;

  const AdminEdit({
    Key? key,
    required this.groupName,
    required this.groupDescription,
  }) : super(key: key);

  @override
  _AdminEditState createState() => _AdminEditState();
}

class _AdminEditState extends State<AdminEdit> {
  final TextEditingController _descriptionController = TextEditingController();
  late String _hintText;

  @override
  initState() {
    super.initState();

    if (widget.groupDescription != null) {
      _descriptionController.text = widget.groupDescription!;
      _descriptionController.selection = TextSelection.fromPosition(
          TextPosition(offset: _descriptionController.text.length));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groupDescription == "") {
      _hintText = StringConstants.groupDescription;
    } else {
      _hintText = "";
    }
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 8, 0),
            child: TextField(
              style: TextStyle(
                fontSize: SizeConfig.safeBlockVertical! * 2.5,
                fontFamily: 'Helvetica',
              ),
              maxLengthEnforcement: MaxLengthEnforcement.none,
              controller: _descriptionController,
              textInputAction: TextInputAction.done,
              cursorColor: Colors.blue,
              maxLines: SizeConfig.safeBlockVertical! * 35 ~/ 20,
              // <--- maxLines
              decoration: InputDecoration(
                hintText: _hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.safeBlockVertical! * 4,
        ),
        PPCRoundedButton(
          title: StringConstants.resignAdmin,
          buttonRatio: .7,
          buttonWidthRatio: .6,
          callback: () {
            _resignAdminSection(widget.groupName);
          },
          bgColor: Colors.blue.shade100,
          textColor: Colors.red,
        ),
      ],
    ); // need to get description data to Firebase TODO
  }

  Widget _resignAdminSection(_groupName) {
    return Column(
      children: const [
        //Need to remove isAdmin status when this button is checked.
        //Also need to add pop up messages
        //Logic is if owner, owner needs to be assigned to someone else so
        //there is always at least one admin for the group
        //if this is the last group member, the group needs to be deleted
        //you cannot delete a group if there are still members and there must
        // be at least one admin
      ],
    );
  }
}
