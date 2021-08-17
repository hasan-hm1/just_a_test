part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final  String  errorMessage;

  AuthError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}


class AuthSuccess extends AuthState {}
class Signedout extends AuthState {}
 