import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:isiphe/enum/meal_type.dart';
import 'package:isiphe/model/meal.dart';

class Summary extends Equatable {
  final double proteinBudget;
  final DateTime date;
  final List<Meal> meals;

  const Summary(this.date, this.proteinBudget, this.meals);

  @override
  List<Object?> get props => [date, proteinBudget, meals];

  double get proteinPerDay => meals.fold(
      0, (previousValue, element) => previousValue + element.protein);

  double get restProteinPerDay => max(proteinBudget - proteinPerDay, 0);

  double getProteinPerMealType(MealType type) {
    return meals
        .where((element) => element.mealType == type)
        .fold(0, (previousValue, element) => previousValue + element.protein);
  }
}
