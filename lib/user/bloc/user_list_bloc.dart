

import 'package:bloc/bloc.dart';
import 'package:exercise1/user/bloc/user_list_event.dart';
import 'package:exercise1/user/bloc/user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {

  UserListBloc() : super (UserListInitial(users: [])) {
    on<AddUserEvent>(_addUser);
    on<DeleteUserEvent>(_deleteUser);
    on<UpdateUserEvent>(_updateUser);

  }


  void _addUser(AddUserEvent event, Emitter<UserListState> emit) {
    state.users.add(event.user);
    emit(UserListUpdated(users: state.users));
  }

  void _deleteUser(DeleteUserEvent event, Emitter<UserListState> emit) {
    state.users.remove(event.user);
    emit(UserListUpdated(users: state.users));
  }

  void _updateUser(UpdateUserEvent event, Emitter<UserListState> emit) {
    for(int i = 0;  i < state.users.length ; i++){
      if(state.users[i].id == event.user.id){
        state.users[i] = event.user;
      }
    }
    emit(UserListUpdated(users: state.users));

  }





}