import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prayer_pals/core/utils/constants.dart';

class StorageRepo {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file) async {
    var userId = UserData.userUID;
    try {
      await _storage.ref(userId).putFile(file);
    } on FirebaseException catch (error) {
      debugPrint(error.toString());
    } catch (err) {
      debugPrint(err.toString());
    }
    return StringConstants.success;
  }

  Future<String> getUserProfileImage() async {
    var userId = UserData.userUID;
    return await _storage.ref().child(userId).getDownloadURL();
  }

  static getUserUID() {
    var _user = FirebaseAuth.instance.currentUser!.uid;
    return _user;
  }
}
