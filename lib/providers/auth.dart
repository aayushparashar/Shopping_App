import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/httpException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userID;
  Timer _authTimer;

  bool get auth {
    return token != null;
  }

  String get userId {
    return _userID;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw httpException(responseData['error']['message']);
      }
      _userID = responseData['localId'];
      _token = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _autoLogout();
      notifyListeners();

      final instance = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userID,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      instance.setString('userData', userData);

//      print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> signout() async{
    _token = null;
    _expiryDate = null;
    _userID = null;
    _authTimer.cancel();
    _authTimer = null;
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> autoLogin() async{
    final inst = await SharedPreferences.getInstance();
    if(!inst.containsKey('userData')){
      return false;
    }
    final userData = json.decode(inst.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }

    _token = userData['token'];
    _userID = userData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToFix = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToFix), signout);
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBpgz9YUDYxbVmv3GrmuzEMO4jpWHKPmKE');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password,
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBpgz9YUDYxbVmv3GrmuzEMO4jpWHKPmKE');
  }
}
