


import 'package:exercise1/user/model/usermodel.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserListEvent{}


class AddUserEvent extends UserListEvent {

  final UserModel user;

  AddUserEvent({required this.user});

}

class DeleteUserEvent extends UserListEvent {
  final UserModel user;

  DeleteUserEvent({required this.user});

}

class UpdateUserEvent extends UserListEvent {
  final UserModel user;

  UpdateUserEvent({required this.user});
  
}
