import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  var _firebaseRef = FirebaseDatabase().reference();
  @override
  GroupState get initialState => GroupInitial();

  @override
  Stream<GroupState> mapEventToState(
    GroupEvent event,
  ) async* {
    if (event is LoadGroupPage) {
      String userhasFriends;
      FirebaseUser user = await FirebaseAuth.instance.currentUser();
      final userid = user.uid;
      var snapshot = await _firebaseRef
          .child('users')
          .child(userid)
          .child('friends')
          .once()
          .then((data) {
        return data.value;
      });
      // once('value',);
      print(snapshot);
      if (snapshot != null) {
        userhasFriends = 'Yes';
      } else {
        userhasFriends = null;
      }
      yield (GroupLoaded(userid, userhasFriends));
    } else if (event is AddContact) {
      // yield (GroupInitial());
      String phone;
      String eventPhone = event.phone.replaceAll(' ', '');
      if (event.phone.startsWith('+')) {
        phone = ('0' + eventPhone.substring(4));
      } else {
        phone = eventPhone;
      }
      var snapshot = await _firebaseRef
          .child('user_info')
          .child(phone)
          .once()
          .then((data) {
        return data.value;
      });
      if (snapshot == null) {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        final userid = user.uid;
        yield (AddFriendLoaded(
            'User does not exist. Click below to invite', phone, event.name));
        yield (GroupLoaded(userid, 'Yes'));
      } else {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        final userid = user.uid;
        // await Sharedpreference().addIntToSF("FRIENDS KEY", -1);
        // int friendsKey = await Sharedpreference().getIntValuesSF("FRIENDS KEY") + 1;
        _firebaseRef
            .child('users')
            .child(user.uid)
            .child('friends')
            .push()
            .set({
          "name": event.name,
          "phone": phone,
        });
        yield (AddFriendLoaded('User added successfully!', phone, event.name));
        yield (GroupLoaded(userid, 'Yes'));
      }
    }
  }
}
