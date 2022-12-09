part of 'food_bloc.dart';

typedef OnFilter = bool Function(FoodType foodType);

class FoodState extends Equatable {
  final List<FoodType> foods;

  final OnFilter onFilter;

  const FoodState({required this.foods, required this.onFilter});

  factory FoodState.unfiltered(List<FoodType> foods) {
    return FoodState(
      foods: foods,
      onFilter: (foodType) => true,
    );
  }

  @override
  List<Object> get props => [foods, favoriteFoods, onFilter];

  List<FoodType> get foodsFiltered => foods.where(onFilter).toList();

  List<FoodType> get favoriteFoods =>
      foodsFiltered.where((element) => element.favorite).toList();

  FoodState copyWith({List<FoodType>? foods, OnFilter? onFilter}) {
    return FoodState(
        foods: foods ?? this.foods, onFilter: onFilter ?? this.onFilter);
  }
}
