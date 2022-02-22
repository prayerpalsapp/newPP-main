import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/group/clients/group_member_client.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';

//////////////////////////////////////////////////////////////////////////
//
//     Used for creating members in the group-> members collection and
//     groups in the users -> groups collection
//
//////////////////////////////////////////////////////////////////////////

final groupMemberRepositoryProvider =
    Provider.autoDispose<GroupMemberRepository>(
        (ref) => GroupMemberRepositoryImpl(ref.read));

abstract class GroupMemberRepository {
  Future<String> createGroupMember(GroupMember groupMember);
  Future<List<GroupMember>> retrieveGroupMember(GroupMember groupMember);
  Future<String> updateGroupMember(GroupMember groupMember);
  Future<String> deleteGroupMember(GroupMember groupMember);
  Future<void> addGroupToMyPendingRequests(
      GroupMember groupMember, PPCUser user);
  Future<String> leaveGroup(String groupUID);
}

class GroupMemberRepositoryImpl implements GroupMemberRepository {
  final Reader _reader;

  const GroupMemberRepositoryImpl(this._reader);

  @override
  Future<String> createGroupMember(GroupMember groupMember) async {
    return await _reader(groupMemberClientProvider)
        .createGroupMember(groupMember);
  }

  @override
  Future<List<GroupMember>> retrieveGroupMember(GroupMember groupMember) async {
    return await _reader(groupMemberClientProvider)
        .retrieveGroupMember(groupMember);
  }

  @override
  Future<String> updateGroupMember(GroupMember groupMember) async {
    return await _reader(groupMemberClientProvider)
        .updateGroupMember(groupMember);
  }

  @override
  Future<String> deleteGroupMember(GroupMember groupMember) async {
    return await _reader(groupMemberClientProvider)
        .deleteGroupMember(groupMember);
  }

  @override
  Future<void> addGroupToMyPendingRequests(
      GroupMember groupMember, PPCUser user) async {
    return await _reader(groupMemberClientProvider)
        .addGroupToMyPendingRequests(groupMember, user);
  }

  @override
  Future<String> leaveGroup(String groupUID) async {
    return await _reader(groupMemberClientProvider).leaveGroup(groupUID);
  }
}
