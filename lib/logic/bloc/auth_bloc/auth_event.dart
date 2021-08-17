part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class Siginup extends AuthEvent {
  final User user;

  Siginup({required this.user});

  @override
  List<Object> get props => [user];
}

class SiginIn extends AuthEvent {
  final User user;

  SiginIn({required this.user});

  @override
  List<Object> get props => [user];
}

class Signout extends AuthEvent {}

class FetchUserType extends AuthEvent {
  final String userId;

  FetchUserType({required this.userId});

  @override
  List<Object> get props => [userId];
}
