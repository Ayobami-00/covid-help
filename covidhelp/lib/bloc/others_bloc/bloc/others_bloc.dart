import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_database/firebase_database.dart';

part 'others_event.dart';
part 'others_state.dart';

class OthersBloc extends Bloc<OthersEvent, OthersState> {
  @override
  OthersState get initialState => OthersInitial();

  @override
  Stream<OthersState> mapEventToState(
    OthersEvent event,
  ) async* {
    if (event is LoadOthers) {
      var _firebaseRef = FirebaseDatabase().reference();
      var phone = await _firebaseRef.child('cdc_help').once().then((data) {
        return data.value;
      });
      Map a = phone;
      List<String> b = [];
      a.forEach((f, k) {
        b.add(f);
      });
      yield OthersLoaded(b,a);
    }
  }
}
