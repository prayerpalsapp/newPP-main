// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prayer_pals/core/utils/providers.dart';
import 'package:prayer_pals/features/user/models/ppcuser.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:uuid/uuid.dart';

final authClientProvider = Provider<AuthClient>((ref) {
  return AuthClient(ref.read(firebaseAuthProvider));
});

class AuthClient {
  final FirebaseAuth _firebaseAuth;
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthClient(this._firebaseAuth);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<String> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return StringConstants.success;
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String> signUp(
      {required String username,
      required String email,
      required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        _saveUserToCloudDB(
          username: username,
          emailAddress: email,
        );
        FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        return StringConstants.success;
      } else {
        return StringConstants.genericError;
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

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
    try {
      if (_firebaseAuth.currentUser!.uid.isNotEmpty) {
        return StringConstants.success;
      } else {
        return StringConstants.genericError;
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  _saveUserToCloudDB({
    required String username,
    required String emailAddress,
  }) {
    PPCUser user = PPCUser(
      username: username,
      emailAddress: emailAddress,
      uid: _firebaseAuth.currentUser!.uid,
      dateJoined: DateTime.now().month.toString() +
          "/" +
          DateTime.now().day.toString() +
          "/" +
          DateTime.now().year.toString(),
      hoursPrayer: 0,
      daysPrayedWeek: 0,
      daysPrayedMonth: 0,
      daysPrayedYear: 0,
      daysPrayedLastYear: 0,
      removedAds: false,
      supportLevel: 0,
      answered: 0,
      prayers: 0,
      imageURL: '',
      subscribedGroups: [],
      groupCreationCredits: 0,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .set(
          user.toJson(),
        );
  }

  Future<String> edit(
      {required String username,
      required String email,
      required String password}) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        _editUserToCloudDB(
          username: username,
          emailAddress: email,
        );
        FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        return StringConstants.success;
      } else {
        return StringConstants.genericError;
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  _editUserToCloudDB({
    required String username,
    required String emailAddress,
  }) {
    PPCUser user = PPCUser(
      username: username,
      emailAddress: emailAddress,
      uid: _firebaseAuth.currentUser!.uid,
      dateJoined: DateTime.now().month.toString() +
          "/" +
          DateTime.now().day.toString() +
          "/" +
          DateTime.now().year.toString(),
      hoursPrayer: 0,
      daysPrayedWeek: 0,
      daysPrayedMonth: 0,
      daysPrayedYear: 0,
      daysPrayedLastYear: 0,
      removedAds: false,
      supportLevel: 0,
      answered: 0,
      prayers: 0,
      imageURL: '',
      subscribedGroups: [],
      groupCreationCredits: 0,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(_firebaseAuth.currentUser!.uid)
        .update(
          user.toJson(),
        );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> forgotPassword({required String emailAddress}) {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);
      return Future.value(StringConstants.success);
    } on FirebaseAuthException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  Future<String> updateUserImage(BuildContext context, File imageFile) async {
    String msg = '';
    final user = FirebaseAuth.instance.currentUser;
    Uuid uuid = const Uuid();

    final String fileName = uuid.v1();
    final firebase_storage.Reference storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child(fileName);
    final firebase_storage.UploadTask uploadTask = storageRef.putFile(
      imageFile,
    );

    final firebase_storage.TaskSnapshot downloadUrl =
        (await uploadTask.whenComplete(() => null));
    final String url = (await downloadUrl.ref.getDownloadURL());

    final docRef = FirebaseFirestore.instance
        .collection(StringConstants.usersCollection)
        .doc(user!.uid);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(docRef, {'imageURL': url});
      msg = url;
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) {
          return Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: AlertDialog(
              title: Text(StringConstants.unknownError),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text(StringConstants.okCaps),
                ),
              ],
            ),
          );
        },
      );
    });

    return msg;
  }

  Future<String?> updateUser(PPCUser user) async {
    String msg = '';
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());
      msg = StringConstants.success;
      return msg;
    } catch (e) {
      debugPrint(e.toString());
      msg = e.toString();
      return msg;
    }
  }
}
