import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authenticate extends ChangeNotifier {
  bool auth = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currUser;
  String _smsVerification;
  var userId;
  bool emailverified = false;

  FirebaseUser get user {
    return _currUser;
  }

  Future<void> updateDisplayName(String name) async {
    UserUpdateInfo _updateData = UserUpdateInfo();
    _updateData.displayName = name;
    await _currUser.updateProfile(_updateData);
    await reloadUser();
  }

  Future<void> signInWithPhone(String phone) async {
    _auth.signOut();
//    return;
    print('signing in');
    try {
      return await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 5),
        verificationCompleted: (credential) async {
          print('Detected!  $credential');
          AuthResult result = await _auth.signInWithCredential(credential);

          print('signed in with credentials');
          _currUser = result.user;
          auth = true;
          print(
              'logged in : ${_currUser.phoneNumber} with email : ${_currUser.email}');
          notifyListeners();
        },
        verificationFailed: (error) {
          print('verification failed');
          print(error.message);
        },
        codeSent: (str, [code]) {
          print('code sent');
          _smsVerification = str;
        },
        codeAutoRetrievalTimeout: (str) {
          print('Timeout there!');
          _smsVerification = str;
        },
      );
    } catch (error) {
      print('Errorrrrr: $error');
      return error;
    }
  }

  Future<bool> autoLogin() async {
    var inst = await SharedPreferences.getInstance();
    if (!inst.containsKey('userData')) {
      return false;
    }
    Map<String, dynamic> details = json.decode(inst.getString('userData'));
    auth = true;
    _currUser = details['user'];
    await isEmailVerified();
  }

  String userEmail() {
    return _currUser.email;
  }

  Future<void> isEmailVerified() async {
    await reloadUser();
    emailverified = _currUser.isEmailVerified;
    notifyListeners();
  }

  Future<void> updateEmail(String email) async {
    await _currUser.updateEmail(email);
    await isEmailVerified();
    reloadUser();
    print('email is: ${_currUser.email}');
    notifyListeners();
  }

  Future<void> sendEmailVerification() async {
    await reloadUser();
    await _currUser.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    _currUser = await _auth.currentUser();
    _currUser.reload();
//    notifyListeners();
  }

  Future<void> signInWithOtp(String otp) async {
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: _smsVerification, smsCode: otp);
      AuthResult result = await _auth.signInWithCredential(credential);
      _currUser = await _auth.currentUser();
      _currUser.updateEmail('temp@temp.com');
      auth = true;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  /////////////////////////////////////////////////////////////////////////////////////
  Future<void> signUp(String email, String password) async {
    AuthResult result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    userId = result.user.uid.toString();
    _currUser = result.user;
    auth = true;
    notifyListeners();
  }

  Future<void> signin(String email, String password) async {
    AuthResult result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    userId = result.user.uid.toString();
    _currUser = result.user;
    auth = true;
    notifyListeners();
  }

  Future<void> google_signin() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    userId = await user.getIdToken().toString();
    _currUser = user;
    auth = true;
    notifyListeners();
  }

  Future<void> logout() {
    _auth.signOut();
    auth = false;
    userId = null;
    _currUser = null;
    notifyListeners();
  }
}
