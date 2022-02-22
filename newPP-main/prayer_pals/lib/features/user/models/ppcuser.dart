import 'package:json_annotation/json_annotation.dart';

part 'ppcuser.g.dart';

@JsonSerializable()
class PPCUser {
  String username;
  String emailAddress;
  String uid;
  String dateJoined;
  int daysPrayedWeek;
  int hoursPrayer;
  int daysPrayedMonth;
  int daysPrayedYear;
  int daysPrayedLastYear;
  bool removedAds;
  int supportLevel;
  List subscribedGroups;
  String? imageURL;
  String? phoneNumber;
  int? answered;
  int? prayers;
  int? groupCreationCredits;

  PPCUser({
    required this.username,
    required this.emailAddress,
    required this.uid,
    required this.dateJoined,
    required this.daysPrayedWeek,
    required this.hoursPrayer,
    required this.daysPrayedMonth,
    required this.daysPrayedYear,
    required this.daysPrayedLastYear,
    required this.removedAds,
    required this.supportLevel,
    required this.subscribedGroups,
    this.imageURL,
    this.phoneNumber,
    this.answered,
    this.prayers,
    this.groupCreationCredits,
  });

  factory PPCUser.fromJson(Map<String, dynamic> json) =>
      _$PPCUserFromJson(json);

  Map<String, dynamic> toJson() => _$PPCUserToJson(this);
}
