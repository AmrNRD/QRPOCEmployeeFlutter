part of 'user_bloc.dart';

abstract class UserState {
   UserState();
}

class UserInitial extends UserState {
   UserInitial();
  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {
   UserLoading();
  @override
  List<Object> get props => [];
}
class UserProfilePictureLoading extends UserState {
  UserProfilePictureLoading();
  @override
  List<Object> get props => [];
}

class UserLoaded extends UserState {
  final User user;
   UserLoaded(this.user);
  @override
  List<Object> get props => [user];
}
class UserProfilePictureLoaded extends UserState {
  UserProfilePictureLoaded();
  @override
  List<Object> get props => [];
}
class UserSignedUp extends UserState {
  final User user;
  UserSignedUp(this.user);
  @override
  List<Object> get props => [user];
}
class UserError extends UserState {
  final String message;
   UserError(this.message);
  @override
  List<Object> get props => [message];
}
class UserMessage extends UserState {
  final String message;
   UserMessage(this.message);
  @override
  List<Object> get props => [message];
}

class VerifyEmailSuccessfully extends UserState {
  final String message;
  VerifyEmailSuccessfully(this.message);
  @override
  List<Object> get props => [message];
}


class ResendVerifyEmailSuccessfully extends UserState {
  final String message;
  ResendVerifyEmailSuccessfully(this.message);
  @override
  List<Object> get props => [message];
}

class UserLoggedOut extends UserState {
  UserLoggedOut();
  @override
  List<Object> get props => [];
}