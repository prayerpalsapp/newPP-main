import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:prayer_pals/core/widgets/ppc_alert_dialog.dart';
import 'package:prayer_pals/features/group/clients/pending_requests_remote_client.dart';
import 'package:prayer_pals/features/group/models/group_member.dart';
import 'package:prayer_pals/features/group/providers/group_member_provider.dart';

final pendingRequestProvider =
    Provider((ref) => PendingRequestProvider(ref.read));

class PendingRequestProvider {
  final Reader _reader;

  PendingRequestProvider(this._reader) : super();

  fetchMyPendingRequests() {
    return _reader(pendingRequestsClientProvider).fetchMyPendingRequests();
  }

  updateGroup(BuildContext ctx, GroupMember groupMember) async {
    await _reader(pendingRequestsClientProvider)
        .removePendingRequest(groupMember);
    final srvMsg =
        await _reader(groupMemberControllerProvider).createGroupMember(
      groupMember.groupMemberUID,
      groupMember.groupMemberName,
      groupMember.groupName,
      groupMember.groupUID,
      false,
      false,
      false,
      false,
      groupMember.emailAddress,
      groupMember.phoneNumber,
      true,
      false,
      false,
      false,
      "",
    );
    if (srvMsg == StringConstants.success) {
    } else {
      showPPCDialog(ctx, StringConstants.almostThere, srvMsg, null);
    }
  }

  removePendingRequest(GroupMember groupMember) {
    _reader(pendingRequestsClientProvider).declinePendingRequest(groupMember);
  }

  removeMyPendingRequestToOtherGroup(GroupMember groupMember) {
    _reader(pendingRequestsClientProvider)
        .removeMyPendingRequestToOtherGroup(groupMember);
  }
}
