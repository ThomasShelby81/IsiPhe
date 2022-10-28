part of 'meal_bloc.dart';

abstract class MealState extends Equatable {
  const MealState();

  @override
  List<Object> get props => [];
}

class MealInitial extends MealState {}

class MealSaved extends MealState {}

class MealNotSaved extends MealState {
  final Object? error;

  const MealNotSaved(this.error);

  @override
  List<Object> get props => [error.toString()];
}
