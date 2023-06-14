import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../../services/http_service.dart';

part 'user_event.dart';
part 'user_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UersInitialState()) {
    on(todosEventControl);
  }

  Future<void> todosEventControl(
      UsersEvent event, Emitter<UsersState> emit) async {
    if (event is UnitUsersStartEvent) {
      emit(UsersLoadingState());
      List<UserModel> todos = [];
      await HttpServices().getAllTodos().then((value) {
        todos = value;
      });
      emit(UsersLoadedState(todos: todos));
    } else if (event is UsersCreateEvent) {
      emit(UsersCreateLoadingState());
      HttpServices().createTodo(event.todo);
      emit(UsersCreateLoadedState());
    } else if (event is UsersUpdateEvent) {
      emit(UsersUpdateLoadingState());
      HttpServices().updateTodo(event.todo);
      emit(UsersUpdateLoadedState());
    } else if (event is UsersDeleteEvent) {
      emit(UsersDeleteLoadingState());
      HttpServices().deleteTodo(event.todo);
      emit(UsersDeleteLoadedState());
    }
  }
}
