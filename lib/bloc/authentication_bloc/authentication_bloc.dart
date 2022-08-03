import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationInitial()) {
    on<AuthenticationStarted>(_authStarted);
    on<AuthenticationLoggedIn>(_loggedIn);
    on<AuthenticationLoggedOut>(_loggedOut);

    /**
    on((event, emit) async {
      if (event is AuthenticationStarted) {
        final isSignIn = await _userRepository.isSignIn();
        if (isSignIn) {
          final user = _userRepository.getUser();
          if (user != null) {
            emit(AuthenticationSuccess(user));
          }
        } else {
          emit(AuthenticationFailure());
        }
      } else if (event is AuthenticationLoggedIn) {
        final user = _userRepository.getUser();
        if (user != null) {
          emit(AuthenticationSuccess(user));
        }
      } else if (event is AuthenticationLoggedOut) {
        emit(AuthenticationLogout());
        _userRepository.signOut();
      }
    });
     */
  }

  Future<FutureOr<void>> _authStarted(
      AuthenticationStarted event, Emitter<AuthenticationState> emit) async {
    final isSignIn = await _userRepository.isSignIn();
    if (isSignIn) {
      final user = _userRepository.getUser();
      if (user != null) {
        emit(AuthenticationSuccess(user));
      }
    } else {
      emit(AuthenticationFailure());
    }
  }

  FutureOr<void> _loggedIn(
      AuthenticationLoggedIn event, Emitter<AuthenticationState> emit) {
    final user = _userRepository.getUser();
    if (user != null) {
      emit(AuthenticationSuccess(user));
    }
  }

  FutureOr<void> _loggedOut(
      AuthenticationLoggedOut event, Emitter<AuthenticationState> emit) {
    emit(AuthenticationLogout());
    _userRepository.signOut();
  }
}
