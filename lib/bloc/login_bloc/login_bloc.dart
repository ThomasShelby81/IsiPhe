import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:isiphe/utils/validators.dart';

import '../../repository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.initial()) {
    on<LoginEmailChange>(_mailChanged);
    on<LoginPasswordChange>(_passwordChanged);
    on<LoginWithCredentials>(_login);
  }

/**
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

 */

  FutureOr<void> _mailChanged(
      LoginEmailChange event, Emitter<LoginState> emit) {
    emit(state.update(
        isEmailValid: Validators.isValidMail(event.email),
        isPasswordValid: true));
  }

  FutureOr<void> _passwordChanged(
      LoginPasswordChange event, Emitter<LoginState> emit) {
    emit(state.update(
        isEmailValid: true,
        isPasswordValid: Validators.isValidPassword(event.password)));
  }

  FutureOr<void> _login(
      LoginWithCredentials event, Emitter<LoginState> emit) async {
    emit(LoginState.loading());
    try {
      await _userRepository.signInWithCredentials(event.email, event.password);
      emit(LoginState.success());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      emit(LoginState.failure());
    }
  }
}
