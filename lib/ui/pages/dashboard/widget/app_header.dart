import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business/bloc/authentication_bloc/authentication_bloc.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Stack(
        children: [
          CustomPaint(
            painter: HeaderPainter(),
            size: const Size(double.infinity, 200),
          ),
          Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                onPressed: () {
                  context
                      .read<AuthenticationBloc>()
                      .add(AuthenticationLoggedOut());
                },
                icon: const Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              )),
          const Positioned(
            top: 35,
            right: 40,
            child: CircleAvatar(
              minRadius: 25,
              maxRadius: 25,
              /**
              foregroundImage: NetworkImage(
                  'https://static.wikia.nocookie.net/disney/images/7/78/180px-A4cf53e959.png/revision/latest/scale-to-width-down/360?cb=20140828162139&path-prefix=de'),
              */
            ),
          ),
          Positioned(
              left: 35,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hallo ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 20),
                  ),
                  Text(
                    user.email.toString(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  )
                ],
              ))
        ],
      ),
    );
  }
}

class HeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint backColor = Paint()..color = const Color(0xff18b0e8);
    Paint circles = Paint()..color = Colors.white.withAlpha(40);

    canvas.drawRect(
      Rect.fromPoints(
        const Offset(0, 0),
        Offset(size.width, size.height),
      ),
      backColor,
    );

    canvas.drawCircle(Offset(size.width * .65, 10), 30, circles);
    canvas.drawCircle(Offset(size.width * .60, 130), 10, circles);
    canvas.drawCircle(Offset(size.width - 10, size.height - 10), 20, circles);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
