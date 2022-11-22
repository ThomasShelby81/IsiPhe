import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isiphe/ui/screens/register/register_screen.dart';
import 'package:isiphe/ui/routes/widgets/gradient_button.dart';

import '../../../business/bloc/authentication_bloc/authentication_bloc.dart';
import '../../../business/bloc/login_bloc/login_bloc.dart';
import '../../../data/repository/user_repository.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isButtonEnabled(LoginState loginState) {
    return loginState.isFormValid && isPopulated && !loginState.isSubmitting;
  }

  late LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _emailController.addListener(_onEmailChange);
    _passwordController.addListener(_onPasswordChange);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text('Loginfehler'),
                  Icon(Icons.error)
                ],
              ),
              backgroundColor: const Color(0xffffae88),
            ));
        }

        if (state.isSubmitting) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Logge ein'),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                ],
              ),
              backgroundColor: const Color(0xffffae88),
            ));
        }

        if (state.isSuccess) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationLoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email), labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.always,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isEmailValid ? 'Fehlerhafte Email' : null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      labelText: "Passwort",
                    ),
                    obscureText: true,
                    autovalidateMode: AutovalidateMode.always,
                    autocorrect: false,
                    validator: (_) {
                      return !state.isPasswordValid
                          ? 'Fehlerhaftes Passwort'
                          : null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GradientButton(
                    width: 160,
                    height: 45,
                    onPressed: () {
                      if (isButtonEnabled(state)) {
                        onFormSubmitted();
                      }
                    },
                    text: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GradientButton(
                    width: 160,
                    height: 45,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return RegisterScreen(
                            userRepository: widget._userRepository);
                      }));
                    },
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    text: const Text(
                      'Registrieren',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChange() {
    _loginBloc.add(LoginEmailChange(email: _emailController.text));
  }

  void _onPasswordChange() {
    _loginBloc.add(LoginPasswordChange(password: _passwordController.text));
  }

  void onFormSubmitted() {
    _loginBloc.add(LoginWithCredentials(
        email: _emailController.text, password: _passwordController.text));
  }
}
