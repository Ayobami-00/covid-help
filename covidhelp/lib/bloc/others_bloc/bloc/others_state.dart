part of 'others_bloc.dart';

abstract class OthersState extends Equatable {
  const OthersState();
}

class OthersInitial extends OthersState {
  @override
  List<Object> get props => [];
}

class OthersLoaded extends OthersState {
  final List<String> othersList;
  final Map othersDict;

  OthersLoaded(this.othersList, this.othersDict);
  @override
  List<Object> get props => [];
}
