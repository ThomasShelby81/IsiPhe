import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:isiphe/business/utils/validators.dart';

import '../../../data/repository/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial()) {
    on<RegisterEmailChanged>(_mapRegisterEmailChangedToState);
    on<RegisterPasswordChanged>(_mapRegisterPasswordChangedToState);
    on<RegisterSubmitted>(_mapRegisterSubmittetdToState);
  }

  FutureOr<void> _mapRegisterEmailChangedToState(
      RegisterEmailChanged event, Emitter<RegisterState> emit) {
    emit(state.update(
        isEmailValid: Validators.isValidMail(event.email),
        isPasswordValid: state.isPasswordValid));
  }

  FutureOr<void> _mapRegisterPasswordChangedToState(
      RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    emit(state.update(
        isEmailValid: state.isEmailValid,
        isPasswordValid: Validators.isValidPassword(event.password)));
  }

  Future<FutureOr<void>> _mapRegisterSubmittetdToState(
      RegisterSubmitted event, Emitter<RegisterState> emit) async {
    emit(RegisterState.loading());
    try {
      await _userRepository.signUp(event.email, event.password);
      emit(RegisterState.success());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      emit(RegisterState.failure());
    }
  }
}
