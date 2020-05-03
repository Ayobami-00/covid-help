part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();
}

class GroupInitial extends GroupState {
  @override
  List<Object> get props => [];
}

class GroupLoaded extends GroupState {
  final String userId;
  final String userhasFriends;

  GroupLoaded(this.userId, this.userhasFriends);
  @override
  List<Object> get props => [];
}

class AddFriendLoaded extends GroupState {
  final String message;
  final String phone;
  final String name;

  AddFriendLoaded(this.message, this.phone, this.name);

 
  @override
  List<Object> get props => [];
}
