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
