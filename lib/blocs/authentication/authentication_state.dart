part of 'authentication_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

final class AuthenticationState extends Equatable {
  final AppStatus status;
  final User user;

  const AuthenticationState._({
    required this.status,
    this.user = User.empty,
  });

  const AuthenticationState.authenticated(User user)
      : this._(status: AppStatus.authenticated, user: user);

  const AuthenticationState.unauthenticated()
      : this._(status: AppStatus.unauthenticated);
  @override
  List<Object?> get props => [status, user];
}
