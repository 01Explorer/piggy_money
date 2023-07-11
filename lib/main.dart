import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:piggy_money/blocs/authentication/authentication_bloc.dart';
import 'package:piggy_money/firebase_options.dart';
import 'package:piggy_money/repositories/authentication_repository.dart';
import 'package:piggy_money/view/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AuthenticationRepository authenticationRepository =
      AuthenticationRepository();

  authenticationRepository.currentUser;
  runApp(App(
    authenticationRepository: authenticationRepository,
  ));
}

class App extends StatelessWidget {
  final AuthenticationRepository _authenticationRepository;

  const App({super.key, required authenticationRepository})
      : _authenticationRepository = authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
            authenticationRepository: _authenticationRepository),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      home: context.select((AuthenticationBloc bloc) {
        switch (bloc.state.status) {
          case AppStatus.authenticated:
            return Container(
              color: Colors.purple,
              child: TextButton(
                onPressed: () =>
                    context.read<AuthenticationRepository>().logOut(),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          default:
            return const LoginView();
        }
      }),
    );
  }
}
