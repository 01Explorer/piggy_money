part of 'sign_in_cubit.dart';

enum SignInStatus {
  initial,
  failure,
  success,
  inProgress,
}

final class SignInState extends Equatable {
  final String email;
  final String password;
  final String confirmationPassword;
  final SignInStatus status;
  final bool isValid;
  final String? errorMessage;

  const SignInState({
    this.email = '',
    this.password = '',
    this.confirmationPassword = '',
    this.status = SignInStatus.initial,
    this.isValid = false,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [email, password, confirmationPassword, status, isValid, errorMessage];

  SignInState copyWith({
    String? email,
    String? password,
    String? confirmationPassword,
    SignInStatus? status,
    bool? isValid,
    String? errorMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmationPassword: confirmationPassword ?? this.confirmationPassword,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
