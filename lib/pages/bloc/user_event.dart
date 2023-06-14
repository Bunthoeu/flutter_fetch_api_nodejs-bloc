part of 'user_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object> get props => [];
}

class UnitUsersStartEvent extends UsersEvent {}

class UsersStartEvent extends UsersEvent {
  final int id;
  const UsersStartEvent(this.id);

  @override
  List<Object> get props => [id];
}

class UsersCreateEvent extends UsersEvent {
  final UserModel todo;
  const UsersCreateEvent(this.todo);
  @override
  List<Object> get props => [todo];
}

class UsersUpdateEvent extends UsersEvent {
  final UserModel todo;
  const UsersUpdateEvent(this.todo);
  @override
  List<Object> get props => [todo];
}

class UsersDeleteEvent extends UsersEvent {
  final UserModel todo;
  const UsersDeleteEvent(this.todo);
  @override
  List<Object> get props => [todo];
}
