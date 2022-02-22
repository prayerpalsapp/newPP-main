import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/providers/ppcuser_core_provider.dart';
import 'package:prayer_pals/features/user/clients/auth_client.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';
import 'package:prayer_pals/features/user/repositories/auth_repository.dart';
import 'package:prayer_pals/core/utils/constants.dart';

enum LoadingState {
  loading,
  done,
}

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authClientProvider).authStateChange;
});

final authControllerProvider =
    ChangeNotifierProvider.autoDispose((ref) => AuthController(ref.read));

class AuthController extends ChangeNotifier {
  final Reader reader;
  String userImage = StringConstants.userIcon;
  AuthController(this.reader);

  signInUser({
    required String emailAddress,
    required String password,
    required Function(String success) callback,
  }) async {
    final srvMsg = await reader(authRepositoryProvider)
        .signIn(emailAddress: emailAddress, password: password);
    callback(srvMsg);
  }

  signUpNewUser(
      {required String username,
      required String emailAddress,
      required String password,
      required Function(String success) callback}) async {
    final srvMsg = await reader(authRepositoryProvider).signUp(
        username: username, emailAddress: emailAddress, password: password);
    callback(srvMsg);
  }

  editUser(
      {required String username,
      required String emailAddress,
      required String password,
      required Function(String success) callback}) async {
    final srvMsg = await reader(authRepositoryProvider).signUp(
        username: username, emailAddress: emailAddress, password: password);
    callback(srvMsg);
  }

/*
  getUser(
      {required String username,
  required String emailAddress,
  required String uid,
  required String dateJoined,
  required int daysPrayedWeek,
  required int hoursPrayer,
  required int daysPrayedMonth,
  required int daysPrayedYear,
  required int daysPrayedLastYear,
  required bool removedAds,
  required int supportLevel,
  int? answered,
  int? prayers,
        required Function(String success) callback}) async {
    final srvMsg = await reader(authRepositoryProvider).signUp(
        username: username, emailAddress: emailAddress, password: password);
    await reader(ppcUserCoreProvider).setupPPUserListener();
    callback(srvMsg);
  }

 */
  Future<String> sendForgotPasswordLink({required String emailAddress}) async {
    final srvMsg = await reader(authRepositoryProvider)
        .forgotPassword(emailAddress: emailAddress);
    if (srvMsg == StringConstants.success) {
      return StringConstants.aPasswordResetEmailWasSent;
    }
    return srvMsg;
  }

  updateUserImage(BuildContext context, File imageFile) async {
    String msg = await reader(authRepositoryProvider)
        .updateUserImage(context, imageFile);
    updateImage(msg);
  }

  updateImage(String imageURL) {
    if (imageURL.isNotEmpty) userImage = imageURL;
    Timer.run(() {
      notifyListeners();
    });
  }

  Future<String?> updateUser(
    BuildContext context,
    String? emailAddress,
    String? username,
    String? phoneNumber,
    PPCUser user,
  ) async {
    if (emailAddress != null) {
      FirebaseAuth.instance.currentUser!.updateEmail(emailAddress);
    }

    if (username != null) {
      FirebaseAuth.instance.currentUser!.updateDisplayName(username);
    }

    if (phoneNumber != null) {
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) {
            FirebaseAuth.instance.currentUser!.updatePhoneNumber(credential);
          },
          verificationFailed: (exception) {
            debugPrint(exception.toString());
          },
          codeSent: (string, integer) {},
          codeAutoRetrievalTimeout: (string) {});
    }
    user.emailAddress = emailAddress!;
    user.username = username!;
    user.phoneNumber = phoneNumber!;
    final srvMsg = await reader(authRepositoryProvider).updateUser(user);
    if (srvMsg == StringConstants.success) {
      notifyListeners();
    }
    return srvMsg;
  }
}
