part of 'meal_bloc.dart';

abstract class MealEvent extends Equatable {
  const MealEvent();

  @override
  List<Object> get props => [];
}

class MealEntered extends MealEvent {
  final Meal meal;

  const MealEntered(this.meal);

  @override
  List<Object> get props => [meal];
}
