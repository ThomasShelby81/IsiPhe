import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isiphe/data/repository/food_repository.dart';
import 'package:isiphe/model/food_type.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository _foodRepository;

  FoodBloc(this._foodRepository) : super(FoodState.unfiltered(const [])) {
    on<FoodInitial>(_onFoodInitial);
    on<FoodDeleteEvent>(_onFoodDelete);
    on<FoodSwitchFavoriteEvent>(_onFoodSwitchFavoriteStatus);
    on<FoodFilterByNameEvent>(_onFoodFilterByNameEvent);
  }

  Future<FutureOr<void>> _onFoodInitial(
      FoodInitial event, Emitter<FoodState> emit) async {
    List<FoodType> foods = await _foodRepository.readFoods();
    emit(state.copyWith(foods: foods));
  }

  FutureOr<void> _onFoodSwitchFavoriteStatus(
      FoodSwitchFavoriteEvent event, Emitter<FoodState> emit) {
    FoodType newFoodType =
        event.foodType.copyWith(favorite: !event.foodType.favorite);

    _foodRepository.changeFavoriteProperty(newFoodType);

    List<FoodType> newList = [
      ...state.foods
          .where((element) => element.favorite == newFoodType.favorite)
          .toList()
    ];
    newList.add(newFoodType);

    emit(state.copyWith(foods: newList));
  }

  Future<FutureOr<void>> _onFoodDelete(
      FoodDeleteEvent event, Emitter<FoodState> emit) async {
    await _foodRepository.delete(event.foodType);

    List<FoodType> newList = [
      ...state.foods
          .where((element) => element.id != event.foodType.id)
          .toList()
    ];

    emit(state.copyWith(foods: newList));
  }

  FutureOr<void> _onFoodFilterByNameEvent(
      FoodFilterByNameEvent event, Emitter<FoodState> emit) {
    emit(state.copyWith(
      foods: state.foods,
      onFilter: (foodType) => foodType.name
          .toLowerCase()
          .contains(event.filterLiteral.toLowerCase()),
    ));
  }
}
