import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Authenticate with ChangeNotifier {
  bool auth = false;
  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference dbreference = FirebaseDatabase.instance.reference();
  StorageReference storageReference = FirebaseStorage.instance.ref();


  Future<void> signin(String email, String password, String nickname) async {
    _auth.verifyPhoneNumber(phoneNumber: null,
        timeout: null,
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: null,
        codeAutoRetrievalTimeout: null)
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final ref = await dbreference.child('userProfile').once();
      final extractedData = ref.value;
      if (!(extractedData.containsKey(result.user.uid.toString()) &&
          extractedData[result.user.uid]['nickname'] == nickname)) {
        throw 'Nickname is not correct!';
      }

      print(extractedData);
      user = result.user;
    } catch (error) {
      throw error;
    }
    auth = true;
    notifyListeners();
  }

  Future<void> signup(String email, String password, String nickname,
      File image) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var ref = FirebaseDatabase.instance
          .reference()
          .child('userProfile')
          .child(result.user.uid.toString())
          .set({
        'nickname': nickname,
      });
      StorageUploadTask task =
      storageReference.child(result.user.uid.toString()).putFile(image);
      await task.onComplete;

      user = result.user;
    } catch (error) {
      print(error);
      throw error;
    }
    auth = true;
    notifyListeners();
  }

  Future<void> logout() {
    _auth.signOut();
    user = null;
    auth = false;
    notifyListeners();
  }

  Future<void> phoneVerify(String phoneNumber) {
    _auth.verifyPhoneNumber(phoneNumber: phoneNumber,
        timeout: Duration(minutes: 5),
        verificationCompleted: (credential){

        },
        verificationFailed: (exception){

        },
        codeSent: null,
        codeAutoRetrievalTimeout: null);
  }
}
