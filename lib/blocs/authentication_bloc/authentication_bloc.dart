import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:isiphe/user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {

  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository}) : _userRepository = userRepository, super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {

    if(event is AuthenticationStarted){
      yield* mapAuthenticationStartedToState();
    }else if(event is AuthenticationLoggedIn){
      yield* mapAuthenticationLoggedInToState();
    }else if(event is AuthenticationLoggedOut){
      yield* mapAuthenticationLogoutToState();
    }

  }

  Stream<AuthenticationState> mapAuthenticationStartedToState() async* {
    final isSignIn =  await _userRepository.isSignIn();
    if(isSignIn){
      final user = _userRepository.getUser();
      if(user != null){
        yield AuthenticationSuccess(user);
      }
    }else{
      yield AuthenticationFailure();
    }
  }

  Stream<AuthenticationState> mapAuthenticationLoggedInToState() async*{
    final user = _userRepository.getUser();
    if(user != null){
      yield AuthenticationSuccess(user);
    }
  }

  Stream<AuthenticationState> mapAuthenticationFailureToState() async*{
    yield AuthenticationFailure();
    _userRepository.signOut();
  }

  Stream<AuthenticationState> mapAuthenticationLogoutToState()async* {
    yield AuthenticationLogout();
    _userRepository.signOut();
  }
}
