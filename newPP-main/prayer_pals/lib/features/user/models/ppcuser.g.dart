// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ppcuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PPCUser _$PPCUserFromJson(Map<String, dynamic> json) => PPCUser(
      username: json['username'] as String,
      emailAddress: json['emailAddress'] as String,
      uid: json['uid'] as String,
      dateJoined: json['dateJoined'] as String,
      daysPrayedWeek: json['daysPrayedWeek'] as int,
      hoursPrayer: json['hoursPrayer'] as int,
      daysPrayedMonth: json['daysPrayedMonth'] as int,
      daysPrayedYear: json['daysPrayedYear'] as int,
      daysPrayedLastYear: json['daysPrayedLastYear'] as int,
      removedAds: json['removedAds'] as bool,
      supportLevel: json['supportLevel'] as int,
      subscribedGroups: json['subscribedGroups'] as List<dynamic>,
      imageURL: json['imageURL'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      answered: json['answered'] as int?,
      prayers: json['prayers'] as int?,
      groupCreationCredits: json['groupCreationCredits'] as int?,
    );

Map<String, dynamic> _$PPCUserToJson(PPCUser instance) => <String, dynamic>{
      'username': instance.username,
      'emailAddress': instance.emailAddress,
      'uid': instance.uid,
      'dateJoined': instance.dateJoined,
      'daysPrayedWeek': instance.daysPrayedWeek,
      'hoursPrayer': instance.hoursPrayer,
      'daysPrayedMonth': instance.daysPrayedMonth,
      'daysPrayedYear': instance.daysPrayedYear,
      'daysPrayedLastYear': instance.daysPrayedLastYear,
      'removedAds': instance.removedAds,
      'supportLevel': instance.supportLevel,
      'subscribedGroups': instance.subscribedGroups,
      'imageURL': instance.imageURL,
      'phoneNumber': instance.phoneNumber,
      'answered': instance.answered,
      'prayers': instance.prayers,
      'groupCreationCredits': instance.groupCreationCredits,
    };
