import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isiphe/ui/pages/dashboard/widget/app_header.dart';
import 'package:isiphe/ui/pages/dashboard/widget/date_selector.dart';
import 'package:isiphe/ui/pages/dashboard/widget/graph.dart';
import 'package:isiphe/ui/pages/dashboard/widget/info.dart';
import 'package:isiphe/ui/pages/dashboard/widget/mealtype_action_button.dart';
import 'package:isiphe/ui/pages/dashboard/widget/stats.dart';
import 'package:isiphe/ui/screens/food/food_screen.dart';

import '../../../business/bloc/currentdate_bloc/currentdate_bloc_bloc.dart';
import '../../../data/repository/meals_repository.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage(
      {Key? key, required this.user, required this.mealsRepository})
      : super(key: key);

  final MealsRepository mealsRepository;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _DashboardPage();
  }
}

class _DashboardPage extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    context.read<CurrentDateBloc>().add(DateInitial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        AppHeader(user: widget.user),
        const Info(),
        const Graph(),
        const SizedBox(
          height: 40,
        ),
        const Stats(),
        const SizedBox(
          height: 40,
        ),
        DateSelector(),
        const SizedBox(
          height: 100,
        )
      ]),
      floatingActionButton: MealTypeActionButton(
        mealsRepository: widget.mealsRepository,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            if (value == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FoodScreen()));
            }
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.no_meals), label: 'Lebensmittel'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Settings')
          ]),
    );
  }
}
