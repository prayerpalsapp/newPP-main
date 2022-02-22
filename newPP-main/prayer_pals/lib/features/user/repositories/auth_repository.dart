import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/features/user/clients/auth_client.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';

final authRepositoryProvider = Provider.autoDispose<AuthRepository>(
    (ref) => AuthRepositoryImpl(reader: ref.read));

abstract class AuthRepository {
  Future<String> signUp(
      {required String username,
      required String emailAddress,
      required String password});
  Future<String> edit(
      {required String username,
      required String emailAddress,
      required String password});
  Future<String> signIn(
      {required String emailAddress, required String password});
  Future<String> getUser(
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
      int? prayers});
  Future<String> forgotPassword({required String emailAddress});
  Future<String> updateUserImage(BuildContext context, File imageFile);
  Future<String?> updateUser(PPCUser user);
}

class AuthRepositoryImpl implements AuthRepository {
  final Reader reader;

  AuthRepositoryImpl({required this.reader});

  @override
  Future<String> signIn(
      {required String emailAddress, required String password}) {
    return reader(authClientProvider)
        .signIn(email: emailAddress, password: password);
  }

  @override
  Future<String> signUp({
    required String username,
    required String emailAddress,
    required String password,
  }) async {
    return await reader(authClientProvider)
        .signUp(username: username, email: emailAddress, password: password);
  }

  @override
  Future<String> edit({
    required String username,
    required String emailAddress,
    required String password,
  }) async {
    return await reader(authClientProvider)
        .edit(username: username, email: emailAddress, password: password);
  }

  @override
  Future<String> getUser(
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
      int? prayers}) async {
    return await reader(authClientProvider).getUser(
        username: username,
        emailAddress: emailAddress,
        uid: uid,
        dateJoined: dateJoined,
        daysPrayedWeek: daysPrayedWeek,
        hoursPrayer: hoursPrayer,
        daysPrayedMonth: daysPrayedMonth,
        daysPrayedYear: daysPrayedYear,
        daysPrayedLastYear: daysPrayedLastYear,
        removedAds: removedAds,
        supportLevel: supportLevel,
        answered: answered,
        prayers: prayers);
  }

  @override
  Future<String> forgotPassword({required String emailAddress}) async {
    return await reader(authClientProvider)
        .forgotPassword(emailAddress: emailAddress);
  }

  @override
  Future<String> updateUserImage(BuildContext context, File imageFile) async {
    String msg =
        await reader(authClientProvider).updateUserImage(context, imageFile);
    return msg;
  }

  @override
  Future<String?> updateUser(PPCUser user) async {
    return await reader(authClientProvider).updateUser(user);
  }
}
