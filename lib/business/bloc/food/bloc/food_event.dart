part of 'food_bloc.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

class FoodInitial extends FoodEvent {
  const FoodInitial();
}

class FoodSwitchFavoriteEvent extends FoodEvent {
  final FoodType foodType;

  const FoodSwitchFavoriteEvent(this.foodType);

  @override
  List<Object> get props => [foodType];
}

class FoodDeleteEvent extends FoodEvent {
  final FoodType foodType;

  const FoodDeleteEvent(this.foodType);

  @override
  List<Object> get props => [foodType];
}

class FoodFilterByNameEvent extends FoodEvent {
  final String filterLiteral;

  const FoodFilterByNameEvent(this.filterLiteral);

  @override
  List<Object> get props => [filterLiteral];
}
