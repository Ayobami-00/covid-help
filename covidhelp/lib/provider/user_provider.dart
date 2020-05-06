import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:covidhelp/services/sharedPreferencesDb.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  var _firebaseRef = FirebaseDatabase().reference().child('users');
  // UserServices _userServices = UserServices();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password,
      String phonenumber, String gender, String dateOfBirth) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        _firebaseRef.child(user.user.uid).set({
          'userId': user.user.uid,
          'name': name,
          'email': email,
          'phone': phonenumber,
          'password': password,
          'gender': gender,
          'dateOfBirth': dateOfBirth,
          'last_wash_date': DateTime.now().toString().substring(0,16),
          'next_wash_date': DateTime.now().toString().substring(0,16),
          'version': 'android',
        });

        FirebaseDatabase().reference().child('user_info').child(phonenumber).set({
          'userId': user.user.uid,
          'name': name,
          'last_wash_date': DateTime.now().toString().substring(0,16),
        });

        Sharedpreference().addStringToSF('FIRST_TIME','True');

        
        print(user.user.uid);
      });
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(FirebaseUser user) async {
    if (user == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = user;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

 }
