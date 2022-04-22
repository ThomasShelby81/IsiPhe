import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:isiphe/user_repository/user_repository.dart';
import 'package:isiphe/utils/validators.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.initial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEmailChange) {
      yield* _mapLoginEmailChangeToState(event.email);
    } else if (event is LoginPasswordChange) {
      yield* _mapLoginPasswordChangeToState(event.password);
    } else if (event is LoginWithCredentials) {
      yield* _mapLoginWithCredentialsChangeToState(event.email, event.password);
    }
  }

  Stream<LoginState> _mapLoginEmailChangeToState(String email) async* {
    yield state.update(
        isEmailValid: Validators.isValidMail(email), isPasswordValid: true);
  }

  Stream<LoginState> _mapLoginPasswordChangeToState(String password) async* {
    yield state.update(
        isEmailValid: true,
        isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<LoginState> _mapLoginWithCredentialsChangeToState(
      String email, String password) async* {
    yield LoginState.loading();

    try {
      await _userRepository.signInWithCredentials(email, password);
      yield LoginState.success();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      yield LoginState.failure();
    }
  }
}
