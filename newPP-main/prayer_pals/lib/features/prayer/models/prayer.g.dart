// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prayer _$PrayerFromJson(Map<String, dynamic> json) => Prayer(
      uid: json['uid'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      creatorUID: json['creatorUID'] as String,
      creatorDisplayName: json['creatorDisplayName'] as String,
      creatorImageURL: json['creatorImageURL'] as String?,
      dateCreated: json['dateCreated'] as String,
      isGlobal: json['isGlobal'] as bool,
      groups: (json['groups'] as List<dynamic>)
          .map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportCount: json['reportCount'] as int?,
      reportedBy: (json['reportedBy'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PrayerToJson(Prayer instance) => <String, dynamic>{
      'uid': instance.uid,
      'title': instance.title,
      'description': instance.description,
      'creatorUID': instance.creatorUID,
      'creatorDisplayName': instance.creatorDisplayName,
      'creatorImageURL': instance.creatorImageURL,
      'dateCreated': instance.dateCreated,
      'isGlobal': instance.isGlobal,
      'reportCount': instance.reportCount,
      'groups': instance.groups.map((e) => e.toJson()).toList(),
      'reportedBy': instance.reportedBy,
    };
