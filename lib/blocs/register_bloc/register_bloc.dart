import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:isiphe/user_repository/user_repository.dart';
import 'package:isiphe/utils/validators.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is RegisterEmailChanged) {
      yield* mapRegisterEmailChangedToState(event.email);
    } else if (event is RegisterPasswordChanged) {
      yield* mapRegisterPasswordChangedToState(event.password);
    } else if (event is RegisterSubmitted) {
      yield* mapRegisterSubmittetdToState(
          email: event.email, password: event.password);
    }
  }

  Stream<RegisterState> mapRegisterEmailChangedToState(String email) async* {
    yield state.update(
        isEmailValid: Validators.isValidMail(email),
        isPasswordValid: state.isPasswordValid);
  }

  Stream<RegisterState> mapRegisterPasswordChangedToState(
      String password) async* {
    yield state.update(
        isEmailValid: state.isEmailValid,
        isPasswordValid: Validators.isValidPassword(password));
  }

  Stream<RegisterState> mapRegisterSubmittetdToState(
      {required String email, required String password}) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(email, password);
      yield RegisterState.success();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      yield RegisterState.failure();
    }
  }
}
