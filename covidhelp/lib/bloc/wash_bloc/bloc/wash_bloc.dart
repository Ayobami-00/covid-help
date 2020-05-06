import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'wash_event.dart';
part 'wash_state.dart';

class WashBloc extends Bloc<WashEvent, WashState> {
  // var _firebaseRef = FirebaseDatabase().reference();
  @override
  WashState get initialState => WashInitial();

  @override
  Stream<WashState> mapEventToState(
    WashEvent event,
  ) async* {
    if (event is LoadWashPage) {
      var _firebaseRef = FirebaseDatabase().reference();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final userid = user.uid;
      String next_wash_date = await _firebaseRef
          .child('users')
          .child(user.uid)
          .child('next_wash_date')
          .once()
          .then((data) {
        return data.value;
      });

      if ((DateTime.now().hour == 21) ||
          (DateTime.now().hour == 6) ||
          ((DateTime.now().hour > 0) && (DateTime.now().hour < 7))) {
        yield HandsWashed("Probably Asleep", "Probably Asleep");
      } else if ((DateTime.now().hour != 21) ||
          (DateTime.now().hour != 6) ||
          (DateTime.now().hour > 7)) {
        String next_wash_date = await _firebaseRef
            .child('users')
            .child(user.uid)
            .child('next_wash_date')
            .once()
            .then((data) {
          return data.value;
        });
        int numberOfMissedWashes = await _calculateNumberofMissedWashes();
        yield HandsWashed(next_wash_date.toString().substring(0, 16),
            numberOfMissedWashes.toString());
      }
    } else if (event is CleanHands) {
      var _firebaseRef = FirebaseDatabase().reference();
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      String phone = await _firebaseRef
          .child('users')
          .child(user.uid)
          .child('phone')
          .once()
          .then((data) {
        return data.value;
      });
      if ((DateTime.now().hour == 21) ||
          (DateTime.now().hour == 6) ||
          ((DateTime.now().hour > 0) && (DateTime.now().hour < 7))) {
        yield HandsWashed("Probably Asleep", "Probably Asleep");
      } else {
        final userid = user.uid;
        DateTime last_wash_date = DateTime.now();
        DateTime next_wash_date = DateTime.now().add(Duration(seconds: 3600));
        _firebaseRef.child('users').child(userid).update({
          'last_wash_date': last_wash_date.toString().substring(0, 16),
          'next_wash_date': next_wash_date.toString().substring(0, 16),
          'number_of_missed_washes' : 0 
        });
        _firebaseRef.child('user_info').child(phone).update({
          'last_wash_date': last_wash_date.toString().substring(0, 16),
          'number_of_missed_washes': 0
        });
        yield HandsWashed(next_wash_date.toString().substring(0, 16), "0");
      }
    }
  }

  _calculateNumberofMissedWashes() async {
    var _firebaseRef = FirebaseDatabase().reference();
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String last_wash_date = await _firebaseRef
        .child('users')
        .child(user.uid)
        .child('last_wash_date')
        .once()
        .then((data) {
      return data.value;
    });

    String phone = await _firebaseRef
        .child('users')
        .child(user.uid)
        .child('phone')
        .once()
        .then((data) {
      return data.value;
    });

    if ((DateTime.now().difference(DateTime.parse(last_wash_date)).inDays)
            .toInt()
            .abs() >
        0) {
      String next_wash_date = DateTime.now()
          .add(Duration(seconds: 3600))
          .toString()
          .substring(0, 16);
      _firebaseRef.child('users').child(user.uid).update({
        'last_wash_date': DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 7)
            .toString()
            .substring(0, 16),
        'next_wash_date': next_wash_date
      });
      int numberOfMissedWashes = (DateTime.now()
                  .difference(DateTime(DateTime.now().year,
                      DateTime.now().month, DateTime.now().day, 7))
                  .inMinutes)
              .toInt()
              .abs() ~/
          45;
      if (numberOfMissedWashes > 1) {
        _firebaseRef.child('users').child(user.uid).update({
          'missed_a_wash': 'true',
          'number_of_missed_washes': numberOfMissedWashes,
        });
        _firebaseRef.child('user_info').child(phone).update({
          'number_of_missed_washes': numberOfMissedWashes,
        });
      }
      return numberOfMissedWashes;
    } else {
      int numberOfMissedWashes =
          (DateTime.parse(last_wash_date).difference(DateTime.now()).inMinutes)
                  .toInt()
                  .abs() ~/
              60;
      if (numberOfMissedWashes > 1) {
        _firebaseRef.child('users').child(user.uid).update({
          'missed_a_wash': 'true',
          'number_of_missed_washes': numberOfMissedWashes,
        });
        _firebaseRef.child('user_info').child(phone).update({
          'number_of_missed_washes': numberOfMissedWashes,
        });
      }else{
        _firebaseRef.child('users').child(user.uid).update({
          'number_of_missed_washes': numberOfMissedWashes,
        });
        _firebaseRef.child('user_info').child(phone).update({
          'number_of_missed_washes': numberOfMissedWashes,
        });
      }

      // else {
      //   _firebaseRef.child('users').child(user.uid).update({
      //     'missed_a_wash': 'true',
      //     'number_of_missed_washes': numberOfMissedWashes,
      //   });
      //   _firebaseRef.child('user_info').child(phone).update({
      //     'number_of_missed_washes': numberOfMissedWashes,
      //   });
      // }
      return numberOfMissedWashes;
    }
  }
}
