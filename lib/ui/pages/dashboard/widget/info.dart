import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../business/bloc/currentdate_bloc/currentdate_bloc_bloc.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          BlocBuilder<CurrentDateBloc, CurrentDateBlocState>(
            builder: (context, state) {
              return Text(
                state.summary.proteinPerDay.toString(),
                style:
                    const TextStyle(fontSize: 33, fontWeight: FontWeight.w900),
              );
            },
          ),
          const Text('Eiweis',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 2,
              )),
          Padding(
            padding: const EdgeInsets.all(15),
            child: BlocBuilder<CurrentDateBloc, CurrentDateBlocState>(
              builder: (context, state) {
                double percent = (state.summary.proteinPerDay /
                            state.summary.proteinBudget *
                            100)
                        .roundToDouble() /
                    100;

                return LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 30,
                  animation: true,
                  lineHeight: 20,
                  animationDuration: 250,
                  percent: percent,
                  barRadius: const Radius.circular(10),
                  progressColor: const Color.fromARGB(255, 77, 124, 142),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
