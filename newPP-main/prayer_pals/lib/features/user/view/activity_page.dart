import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prayer_pals/core/utils/size_config.dart';
import 'package:prayer_pals/core/widgets/ppc_logo_widget.dart';
import 'package:prayer_pals/core/widgets/user_info_bar.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';
import 'package:prayer_pals/core/utils/constants.dart';

class Activity extends StatefulWidget {
  final PPCUser ppcUser;
  const Activity({Key? key, required this.ppcUser}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  @override
  Widget build(BuildContext context) {
    int _totalUsers = 4;
    // TODO get from Firestore Collection(globalPrayers)Doc(counter)
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            StringConstants.activity,
          ),
          centerTitle: true,
        ),
        body: _contentSection(_totalUsers));
  }

  Widget _contentSection(_totalUsers) {
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UserInfoBarWidget(isSettings: false),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                StringConstants.memberSince,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical! * 3,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.ppcUser.dateJoined,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical! * 3,
                ),
              ),
            ),
          ],
        ),
        _detailRow(widget.ppcUser.answered, StringConstants.answeredPrayers),
        _detailRow(widget.ppcUser.prayers, StringConstants.prayersRequested),
        _detailRow(widget.ppcUser.hoursPrayer, StringConstants.hoursInPrayer),
        _detailRow(
            widget.ppcUser.daysPrayedWeek, StringConstants.daysPrayedWeek),
        _detailRow(
            widget.ppcUser.daysPrayedMonth, StringConstants.daysPrayedMonth),
        _detailRow(
            widget.ppcUser.daysPrayedYear, StringConstants.daysPrayedYear),
        _detailRow(widget.ppcUser.daysPrayedLastYear,
            StringConstants.daysPrayedLastYear),
        PPCstuff.divider,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 7),
              child: Text(
                Globals.numberFormat
                    .format(int.parse(_totalUsers.toStringAsFixed(0))),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical! * 3,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 4),
                child: Text(
                  StringConstants.prayerPals,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical! * 3,
                  ),
                )),
            const PPCLogoWidget(size: 2.2),
          ],
        ),
      ],
    );
    return const Text("");
  }

  Widget _detailRow(_values, _label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              _values.toStringAsFixed(0),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockVertical! * 3,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              _label,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: SizeConfig.safeBlockVertical! * 3,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
