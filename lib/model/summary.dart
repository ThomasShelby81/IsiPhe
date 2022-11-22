import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:isiphe/model/enum/meal_type.dart';
import 'package:isiphe/model/meal.dart';

import 'data_point.dart';

class Summary extends Equatable {
  final double proteinBudget;
  final DateTime date;
  final List<Meal> meals;
  final List<DataPoint> history;

  const Summary(this.date, this.proteinBudget, this.meals, this.history);

  double get proteinPerDay => meals.fold(
      0, (previousValue, element) => previousValue + element.protein);

  double get restProteinPerDay => max(proteinBudget - proteinPerDay, 0);

  List<DataPoint> get tenDayHistory => history;

  double getProteinPerMealType(MealType type) {
    return meals
        .where((element) => element.mealType == type)
        .fold(0, (previousValue, element) => previousValue + element.protein);
  }

  @override
  List<Object?> get props => [date, proteinBudget, meals, history];
}
