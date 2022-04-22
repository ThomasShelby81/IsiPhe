import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isiphe/blocs/register_bloc/register_bloc.dart';
import 'package:isiphe/screens/register/register_form.dart';
import 'package:isiphe/user_repository/user_repository.dart';
import 'package:isiphe/widgets/curved_widget.dart';

class RegisterScreen extends StatelessWidget{
  final UserRepository _userRepository;

  const RegisterScreen({ Key? key, required UserRepository userRepository}) : _userRepository= userRepository, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Color(0xff6a515e),
        ),
      ),
      body:  BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(userRepository: _userRepository),
        child: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfff2cbd0), Color(0xfff4ced9)]
            ),
          ),
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                CurvedWidget(
                  child: Container(
                    padding: const EdgeInsets.only(top: 100, left: 50),
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white.withOpacity(0.4)],
                      )
                    ),
                    child: const Text('Register', style: TextStyle(fontSize: 40, color: Color(0xff6a515e)),),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 230),
                  child: const RegisterForm(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}