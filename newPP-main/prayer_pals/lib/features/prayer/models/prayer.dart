import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prayer.g.dart';

@JsonSerializable(explicitToJson: true)
class Prayer {
  String uid;
  String title;
  String description;
  String creatorUID;
  String creatorDisplayName;
  String? creatorImageURL;
  String dateCreated;
  bool isGlobal;
  int? reportCount;
  List<Group> groups;
  List<String>? reportedBy;

  Prayer({
    required this.uid,
    required this.title,
    required this.description,
    required this.creatorUID,
    required this.creatorDisplayName,
    required this.creatorImageURL,
    required this.dateCreated,
    required this.isGlobal,
    required this.groups,
    this.reportCount,
    this.reportedBy,
  });
  factory Prayer.fromJson(Map<String, dynamic> json) => _$PrayerFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerToJson(this);

  factory Prayer.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Prayer.fromJson(data);
  }
}
