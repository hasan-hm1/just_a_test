import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_test/data/models/auth/user.dart';
import 'package:interview_test/data/models/other/errors.dart';
import 'package:interview_test/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthRepository authRepository;
  AuthBloc(this.authRepository) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
   
    yield AuthLoading();

    try {
      if (event is Siginup) {
        await authRepository.signup(event.user);
        yield AuthSuccess();
      } else if (event is SiginIn) {
        await authRepository.signin(event.user);
        yield AuthSuccess();
      } else if (event is Signout) {
        await authRepository.signout();
        yield Signedout();
      } else if (event is FetchUserType) {
        await authRepository.fetchUserType(event.userId);
        yield AuthSuccess();
      }
    } on AppError catch (e) {
      yield AuthError(errorMessage: e.errorMessage!);
    }
  }
}
