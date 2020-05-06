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
  final String numberOfMissedWashes;

  HandsWashed(this.nextWashDate, this.numberOfMissedWashes);

  
  @override
  List<Object> get props => [nextWashDate];
}

