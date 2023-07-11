import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggy_money/core/exceptions/authentication_exceptions.dart';
import 'package:piggy_money/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginCubit(this._authenticationRepository) : super(const LoginState());

  Future<void> logInWithCredentials(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
          email: email, password: password);
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: LoginStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.inProgress));
    try {
      await _authenticationRepository.signInWithGoogle();
      emit(state.copyWith(status: LoginStatus.success));
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: LoginStatus.failure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: LoginStatus.failure));
    }
  }
}
