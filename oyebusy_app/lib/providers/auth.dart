import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authenticate extends ChangeNotifier {
  bool auth = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currUser ;
  var userId;

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
  Future<void> logout (){
    _auth.signOut();
    auth = false;
    userId = null;
    _currUser = null;
    notifyListeners();
  }
}
