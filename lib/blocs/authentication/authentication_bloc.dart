import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggy_money/repositories/authentication_repository.dart';

import '../../models/user_model.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  AuthenticationBloc(
      {required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser != User.empty
              ? AuthenticationState.authenticated(
                authenticationRepository.currentUser)
              : const AuthenticationState.unauthenticated(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);

    _userSubscription = _authenticationRepository.user
        .listen((user) => add(_AppUserChanged(user)));
  }

  void _onUserChanged(
      _AppUserChanged event, Emitter<AuthenticationState> emit) {
    emit(
      !event.user.isEmpty
          ? AuthenticationState.authenticated(event.user)
          : const AuthenticationState.unauthenticated(),
    );
  }

  void _onLogoutRequested(
      AppLogoutRequested event, Emitter<AuthenticationState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
