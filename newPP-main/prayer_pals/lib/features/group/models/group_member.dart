import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group_member.g.dart';

@JsonSerializable()
class GroupMember {
  GroupMember({
    required this.groupMemberUID,
    required this.groupMemberName,
    required this.groupName,
    required this.groupUID,
    this.groupImageURL,
    required this.isAdmin,
    required this.isOwner,
    required this.isCreated,
    required this.isInvited,
    required this.emailAddress,
    required this.phoneNumber,
    required this.appNotify,
    required this.textNotify,
    required this.emailNotify,
    required this.isPending,
  });

  String groupMemberUID;
  String groupMemberName;
  String groupName;
  String groupUID;
  String? groupImageURL;
  bool isAdmin;
  bool isOwner;
  bool isCreated;
  bool isInvited;
  String emailAddress;
  String phoneNumber;
  bool appNotify;
  bool textNotify;
  bool emailNotify;
  bool isPending;

  factory GroupMember.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMemberToJson(this);

  factory GroupMember.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return GroupMember.fromJson(data);
  }

  factory GroupMember.fromQuerySnapshot(
      QuerySnapshot<Object?> data, int index) {
    GroupMember groupMember = GroupMember(
      groupMemberUID: data.docs[index]['groupMemberUID'],
      groupMemberName: data.docs[index]['groupMemberName'],
      groupName: data.docs[index]['groupName'],
      groupUID: data.docs[index]['groupUID'],
      isAdmin: data.docs[index]['isAdmin'],
      isOwner: data.docs[index]['isOwner'],
      isCreated: data.docs[index]['isCreated'],
      isInvited: data.docs[index]['isInvited'],
      emailAddress: data.docs[index]['emailAddress'],
      phoneNumber: data.docs[index]['phoneNumber'],
      appNotify: data.docs[index]['appNotify'],
      textNotify: data.docs[index]['textNotify'],
      emailNotify: data.docs[index]['emailNotify'],
      isPending: data.docs[index]['isPending'],
      groupImageURL: data.docs[index]['groupImageURL'] ?? '',
    );
    return groupMember;
  }
}
