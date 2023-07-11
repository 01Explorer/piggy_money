import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:piggy_money/core/exceptions/authentication_exceptions.dart';
import 'package:piggy_money/repositories/authentication_repository.dart';

part 'sign_in_state.dart';

typedef AuthInput = ({String email, String password});

class SignInCubit extends Cubit<SignInState> {
  final AuthenticationRepository _authenticationRepository;

  SignInCubit(this._authenticationRepository) : super(const SignInState());

  Future<void> signUpWithEmailAndPassword(AuthInput authInput) async {
    emit(state.copyWith(status: SignInStatus.inProgress));
    try {
      await _authenticationRepository.createUserWithEmailAndPassword(
          email: authInput.email, password: authInput.password);
      emit(state.copyWith(status: SignInStatus.success));
    } on SignUpWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: SignInStatus.failure));
    }
  }
}
