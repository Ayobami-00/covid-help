import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserServices {
  FirebaseAuth _auth;
  FirebaseUser _user;
  FirebaseUser get user => _user;
  var _firebaseRef = FirebaseDatabase().reference().child('users');

  Future<bool> checkIfUserHasFriends() async {
    final FirebaseUser currentUser = await _auth.currentUser();
    _firebaseRef
        .child(currentUser.uid)
        .child('friends')
        .once()
        .then((DataSnapshot data) {
      if (data.value != null) {
        return true;
      } else {
        return false;
      }
    });
  }
}
