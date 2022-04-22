import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isiphe/blocs/authentication_bloc/authentication_bloc.dart';

class Dashboard extends StatefulWidget {
  final User user;

  const Dashboard({Key? key, required this.user}) : super(key: key);

  @override
  _Dashboard createState() {
    return _Dashboard();
  }
}

class _Dashboard extends State<Dashboard> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationLoggedOut());
            }),
        title: const Text('Dashboard',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://static.wikia.nocookie.net/disney/images/7/78/180px-A4cf53e959.png/revision/latest/scale-to-width-down/360?cb=20140828162139&path-prefix=de'),
            ),
            onPressed: () => debugPrint('pressed'),
          ),
          /**
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationLoggedOut());
              })
               */
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text('Hello, ${widget.user.email}'),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => debugPrint("pressed"),
          child: AnimatedIcon(
            icon: AnimatedIcons.add_event,
            progress: _animation,
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar:
          BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings')
      ]),
    );
  }
}
