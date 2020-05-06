part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();
}

class LoadGroupPage extends GroupEvent{
  @override
  List<Object> get props => null;

}

class AddContact extends GroupEvent{
  final String name;
  final String phone;

  AddContact(this.name, this.phone);
  @override
  List<Object> get props => null;

}
