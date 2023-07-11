import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggy_money/blocs/cubit/sign_in_cubit.dart';
import 'package:piggy_money/repositories/authentication_repository.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (context) =>
              SignInCubit(context.read<AuthenticationRepository>()),
          child: _SignUpForm(),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _confirmPasswordTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInCubit, SignInState>(
        listener: (context, state) {
          if (state.status == SignInStatus.failure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Sign Up Failure'),
                ),
              );
          }
          if (state.status == SignInStatus.success) {
            Navigator.pop(context);
          }
        },
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Sign Up'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailTextEditingController,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordTextEditingController,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordTextEditingController,
                    decoration: const InputDecoration(
                        hintText: 'Confirm your password'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await context
                              .read<SignInCubit>()
                              .signUpWithEmailAndPassword((
                            email: _emailTextEditingController.text,
                            password: _passwordTextEditingController.text
                          ));
                        }
                      },
                      child: const Text('Sign Up'))
                ],
              ),
            ),
          ),
        ));
  }
}
