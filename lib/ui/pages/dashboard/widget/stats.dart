import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:isiphe/model/enum/meal_type.dart';

import '../../../../business/bloc/currentdate_bloc/currentdate_bloc_bloc.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentDateBloc, CurrentDateBlocState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stat(
                value: state.summary.getProteinPerMealType(MealType.breakfast),
                label: 'Frühstück'),
            Stat(
                value: state.summary.getProteinPerMealType(MealType.lunch),
                label: 'Mittag'),
            Stat(
                value: state.summary.getProteinPerMealType(MealType.dinner),
                label: 'Abend'),
            Stat(
                value: state.summary.getProteinPerMealType(MealType.snack),
                label: 'Snack'),
          ],
        );
      },
    );
  }
}

class Stat extends StatelessWidget {
  final double value;
  final String label;

  const Stat({Key? key, required this.value, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text.rich(TextSpan(
            text: value.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            children: const [
              TextSpan(
                  text: 'g',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500))
            ])),
        const SizedBox(
          height: 6,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}
