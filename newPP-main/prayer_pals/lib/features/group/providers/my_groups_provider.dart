import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/group/clients/my_groups_remote_client.dart';

final myGroupsControllerProvider =
    Provider((ref) => MyGroupsController(ref.read));

class MyGroupsController {
  final Reader reader;
  const MyGroupsController(this.reader);

  Stream<QuerySnapshot> fetchMyGroups() {
    return reader(myGroupsClientProvider).fetchMyGroups();
  }
}
