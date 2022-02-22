// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      creatorUID: json['creatorUID'] as String?,
      description: json['description'] as String?,
      groupUID: json['groupUID'] as String,
      groupName: json['groupName'] as String,
      groupImageURL: json['groupImageURL'] as String?,
      isPrivate: json['isPrivate'] as bool?,
      memberCount: json['memberCount'] as int?,
      prayerCount: json['prayerCount'] as int?,
      searchParamsList: json['searchParamsList'] as List<dynamic>?,
      subscribed: json['subscribed'] as bool?,
      tags: json['tags'] as String?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'creatorUID': instance.creatorUID,
      'description': instance.description,
      'groupUID': instance.groupUID,
      'groupName': instance.groupName,
      'groupImageURL': instance.groupImageURL,
      'isPrivate': instance.isPrivate,
      'memberCount': instance.memberCount,
      'prayerCount': instance.prayerCount,
      'searchParamsList': instance.searchParamsList,
      'subscribed': instance.subscribed,
      'tags': instance.tags,
    };
