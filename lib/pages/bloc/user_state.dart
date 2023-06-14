part of 'user_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object> get props => [];
}

class UersInitialState extends UsersState {}

class UsersLoadingState extends UsersState {}

class UsersLoadedState extends UsersState {
  final List<UserModel> todos;
  const UsersLoadedState({required this.todos});
  @override
  List<Object> get props => [todos];
}

class UsersCreateLoadingState extends UsersState {}

class UsersCreateLoadedState extends UsersState {}

class UsersUpdateLoadingState extends UsersState {}

class UsersUpdateLoadedState extends UsersState {}

class UsersDeleteLoadingState extends UsersState {}

class UsersDeleteLoadedState extends UsersState {}
