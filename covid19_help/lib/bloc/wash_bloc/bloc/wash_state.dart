part of 'wash_bloc.dart';

abstract class WashState extends Equatable {
  const WashState();
}

class WashInitial extends WashState {
  @override
  List<Object> get props => [];
}


class HandsWashed extends WashState {
  final String nextWashDate;

  HandsWashed(this.nextWashDate);
  @override
  List<Object> get props => [nextWashDate];
}

