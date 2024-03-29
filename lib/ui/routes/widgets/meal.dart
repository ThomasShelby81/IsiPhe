import 'package:flutter/material.dart';

class MealDisplay extends StatelessWidget {
  final String name;
  final double phe;

  const MealDisplay({Key? key, required this.name, required this.phe})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        name,
        style: Theme.of(context).textTheme.headline1,
      ),
      Text(
        phe.toString(),
        style: Theme.of(context).textTheme.headline2,
      ),
      const SizedBox(
        height: 20,
      ),
    ]);
  }
}
