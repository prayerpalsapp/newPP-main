import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  String? creatorUID;
  String? description;
  String groupUID;
  String groupName;
  String? groupImageURL;
  bool? isPrivate;
  int? memberCount;
  int? prayerCount;
  List? searchParamsList;
  bool? subscribed;
  String? tags;

  Group({
    this.creatorUID,
    this.description,
    required this.groupUID,
    required this.groupName,
    this.groupImageURL,
    this.isPrivate,
    this.memberCount,
    this.prayerCount,
    this.searchParamsList,
    this.subscribed,
    this.tags,
  });
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);

  factory Group.fromQuerySnapshot(QuerySnapshot<Object?> data, int index) {
    return Group(
      groupUID: data.docs[index]['groupUID'],
      groupName: data.docs[index]['groupName'],
      description: data.docs[index]['description'],
      creatorUID: data.docs[index]['creatorUID'],
      isPrivate: data.docs[index]['isPrivate'],
      tags: data.docs[index]['tags'],
      groupImageURL: data.docs[index]['groupImageURL'],
      memberCount: data.docs[index]['memberCount'],
      prayerCount: data.docs[index]['prayerCount'],
      searchParamsList: data.docs[index]['searchParamsList'],
      subscribed: data.docs[index]['subscribed'],
    );
  }
}
