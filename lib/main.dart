import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isiphe/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:isiphe/blocs/currentdate_bloc/currentdate_bloc_bloc.dart';
import 'package:isiphe/screens/dashboard.dart';
import 'package:isiphe/screens/login/login_screen.dart';
import 'package:isiphe/user_repository/user_repository.dart';

import 'blocs/simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Bloc.observer = SimpleBlocObserver();
  var userRepository = UserRepository();
  runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: UserRepository(),
      )..add(AuthenticationStarted()),
      child: MyApp(
        userRepository: userRepository,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository;

  const MyApp({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      debugShowCheckedModeBanner: true,
      title: 'Isi Phe',
      theme: ThemeData(
          textTheme: TextTheme(
            headline1: GoogleFonts.lato(
                fontSize: 16,
                textStyle: TextStyle(
                    color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
            headline2: GoogleFonts.lato(
                fontSize: 20,
                textStyle: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
          ),
          primaryColor: const Color(0xff6a515e),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xff6a515e),
          )),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationFailure || state is AuthenticationLogout) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is AuthenticationSuccess) {
            return BlocProvider(
              create: (context) => CurrentDateBloc(),
              child: Dashboard(user: state.user),
            );
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('Loading'),
            ),
          );
        },
      ),
    );
  }
}
