import 'dart:async';

import 'package:QRFlutter/data/models/user_model.dart';
import 'package:QRFlutter/data/repositories/user_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(null);

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield UserLoading();
    try {
      if (event is GetUser) {
         Root.user = await userRepository.fetchUserData();
        yield UserLoaded(Root.user);
      } else if (event is LoginUser) {
        Root.user = await userRepository.login(event.email, event.password, event.platform, event.firebaseToken);
        yield UserLoaded(Root.user);
      } else if (event is LogoutUser) {
        Root.user = await userRepository.logout();
        yield UserLoggedOut();
      }
    } catch (error) {
      debugPrint("Error happened in SettingsBloc of type ${error.runtimeType} with output ' ${error.toString()} '");
      yield UserError(error.toString());
    }
  }
}
