import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/providers/ppcuser_core_provider.dart';
import 'package:prayer_pals/features/group/models/group.dart';
import 'package:prayer_pals/features/prayer/models/prayer.dart';
import 'package:prayer_pals/features/prayer/providers/global_prayer_provider.dart';
import 'package:prayer_pals/features/prayer/repositories/my_prayer_repository.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';
import 'package:uuid/uuid.dart';
import '../../../core/utils/constants.dart';

final prayerControllerProvider = ChangeNotifierProvider<PrayerController>(
    (ref) => PrayerController(ref.read));

class PrayerController extends ChangeNotifier {
  final Reader _reader;

  PrayerController(this._reader) : super();

  Future<String> createPrayer(String? title, String? description,
      String creatorUID, List<Group> groupsToAdd, bool isGlobal) async {
    String message = '';

    if (title == null || title.isEmpty) {
      message = StringConstants.createPrayerErrorNoTitle;
    }

    if (description == null || description.isEmpty) {
      message = message + '\n${StringConstants.createPrayerErrorNoDescription}';
    }
    if (message.isNotEmpty) {
      return message;
    } else {
      Uuid uuid = const Uuid();
      String prayerId = uuid.v1();
      PPCUser currentUser =
          await _reader(ppcUserCoreProvider).currentUserNetworkFetch();

      Prayer prayer = Prayer(
        uid: prayerId,
        title: title!,
        description: description!,
        creatorUID: creatorUID,
        creatorDisplayName: currentUser.username,
        creatorImageURL: currentUser.imageURL ?? StringConstants.userIcon,
        dateCreated:
            DateFormat("MM-dd-yyyy hh:mm a").format(DateTime.now()).toString(),
        isGlobal: isGlobal,
        groups: groupsToAdd,
        reportCount: 0,
        reportedBy: [],
      );
      return await _reader(prayerRepositoryProvider).createPrayer(prayer);
    }
  }

  Future<List<Prayer>> retrievePrayers(PrayerType prayerType) async {
    return await _reader(prayerRepositoryProvider).retrievePrayers(prayerType);
  }

  Future<String> updatePrayer(
      PrayerType prayerType,
      String uid,
      String? title,
      String? description,
      String creatorUID,
      String displayName,
      String dateCreated,
      List<Group> groupsToAdd,
      List<Group> groupsToUpdateAdd,
      List<Group> groupsToUpdateDelete,
      bool isGlobal) async {
    String message = '';

    if (title == null || title.isEmpty) {
      message = StringConstants.createPrayerErrorNoTitle;
    }

    if (description == null || description.isEmpty) {
      message = message + '\n${StringConstants.createPrayerErrorNoDescription}';
    }
    if (message.isNotEmpty) {
      return message;
    } else {
      PPCUser currentUser =
          await _reader(ppcUserCoreProvider).currentUserNetworkFetch();
      Prayer prayer = Prayer(
        uid: uid,
        title: title!,
        description: description!,
        creatorUID: creatorUID,
        creatorDisplayName: displayName,
        creatorImageURL: currentUser.imageURL ?? StringConstants.userIcon,
        dateCreated: dateCreated,
        groups: groupsToAdd,
        isGlobal: isGlobal,
      );
      final msg = await _reader(prayerRepositoryProvider).updatePrayer(
        prayer,
        prayerType,
        groupsToUpdateDelete,
        groupsToUpdateAdd,
      );
      await _reader(globalPrayerControllerProvider).notify();
      notify();
      return msg;
    }
  }

  Future<String> deletePrayer(Prayer prayer, PrayerType prayerType) async {
    String result = await _reader(prayerRepositoryProvider)
        .deletePrayer(prayer, prayerType);
    if (result == StringConstants.success) {
      _reader(globalPrayerControllerProvider).notify();
      notify();
    }
    return result;
  }

  Future<List<Group>> fetchGroupsForCurrentUser() async {
    return await _reader(prayerRepositoryProvider).fetchGroupsForCurrentUser();
  }

  Future<void> makeAnsweredPrayerUnanswered(Prayer prayer) async {
    await _reader(prayerRepositoryProvider)
        .makeAnsweredPrayerUnanswered(prayer);
    await _reader(globalPrayerControllerProvider).notify();
    notify();
    return;
  }

  notify() {
    notifyListeners();
  }
}
