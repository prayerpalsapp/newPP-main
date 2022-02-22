// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMember _$GroupMemberFromJson(Map<String, dynamic> json) => GroupMember(
      groupMemberUID: json['groupMemberUID'] as String,
      groupMemberName: json['groupMemberName'] as String,
      groupName: json['groupName'] as String,
      groupUID: json['groupUID'] as String,
      groupImageURL: json['groupImageURL'] as String?,
      isAdmin: json['isAdmin'] as bool,
      isOwner: json['isOwner'] as bool,
      isCreated: json['isCreated'] as bool,
      isInvited: json['isInvited'] as bool,
      emailAddress: json['emailAddress'] as String,
      phoneNumber: json['phoneNumber'] as String,
      appNotify: json['appNotify'] as bool,
      textNotify: json['textNotify'] as bool,
      emailNotify: json['emailNotify'] as bool,
      isPending: json['isPending'] as bool,
    );

Map<String, dynamic> _$GroupMemberToJson(GroupMember instance) =>
    <String, dynamic>{
      'groupMemberUID': instance.groupMemberUID,
      'groupMemberName': instance.groupMemberName,
      'groupName': instance.groupName,
      'groupUID': instance.groupUID,
      'groupImageURL': instance.groupImageURL,
      'isAdmin': instance.isAdmin,
      'isOwner': instance.isOwner,
      'isCreated': instance.isCreated,
      'isInvited': instance.isInvited,
      'emailAddress': instance.emailAddress,
      'phoneNumber': instance.phoneNumber,
      'appNotify': instance.appNotify,
      'textNotify': instance.textNotify,
      'emailNotify': instance.emailNotify,
      'isPending': instance.isPending,
    };
