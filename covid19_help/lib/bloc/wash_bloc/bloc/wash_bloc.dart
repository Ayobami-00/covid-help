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
      if(next_wash_date == "Probably Asleep" && (((DateTime.now().hour == 22) ||
        (DateTime.now().hour == 6)) && 
        (DateTime.now().hour < 7))){
          yield HandsWashed(next_wash_date);
      }
      else if(next_wash_date == "Probably Asleep" && (((DateTime.now().hour != 22) ||
        (DateTime.now().hour != 6)) && 
        (DateTime.now().hour > 7))){
          String update = DateTime.now().add(Duration(seconds: 3600)).toString().substring(0,16);
        _firebaseRef.child('users').child(userid).update({
          'next_wash_date': update,
        });
        yield HandsWashed(update);
        }
      else{
        if((DateTime.now().difference(DateTime.parse(next_wash_date)).inDays).toInt() >= 1){
        String next_wash_date = DateTime.now().add(Duration(seconds: 3600)).toString().substring(0,16);
        _firebaseRef.child('users').child(userid).update({
          'next_wash_date': next_wash_date,
        });
        yield HandsWashed(next_wash_date);
        

      }
      else{
        yield HandsWashed(next_wash_date);
      }

      }
      
      
     
      }
      else if(event is CleanHands){

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
      if (((DateTime.now().hour != 22) ||
        (DateTime.now().hour != 6)) && 
        (DateTime.now().hour > 7)) {
      final userid = user.uid;
      DateTime last_wash_date = DateTime.now();
      DateTime next_wash_date = DateTime.now().add(Duration(seconds: 3600));
      _firebaseRef.child('users').child(userid).update({
          'last_wash_date': last_wash_date.toString().substring(0,16),
          'next_wash_date': next_wash_date.toString().substring(0,16),
        });
      _firebaseRef.child('user_info').child(phone)..update({
          'last_wash_date': last_wash_date.toString().substring(0,16),
        });
        yield HandsWashed(next_wash_date.toString().substring(0,16));
      }
      else{
        final userid = user.uid;
        _firebaseRef.child('users').child(userid).update({
          'last_wash_date': "Probably Asleep",
          'next_wash_date': "Probably Asleep",
        });
      _firebaseRef.child('user_info').child(phone).update({
          'last_wash_date': "Probably Asleep",
        });
        yield HandsWashed("Probably Asleep");
      }

       

      }
    }
  }



 