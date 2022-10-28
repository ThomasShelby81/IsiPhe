import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:isiphe/model/meal.dart';
import 'package:isiphe/repository/meals_repository.dart';

part 'meal_event.dart';
part 'meal_state.dart';

class MealBloc extends Bloc<MealEvent, MealState> {
  final MealsRepository _mealsRepository;

  MealBloc(this._mealsRepository) : super(MealInitial()) {
    on<MealEntered>((event, emit) async {
      await _mealsRepository.writeMeal(event.meal).then(
        (value) {
          emit(MealSaved());
        },
      ).onError(
        (error, stackTrace) {
          log(error.toString());
          debugPrintStack(stackTrace: stackTrace);
          emit(MealNotSaved(error));
        },
      );
    });
  }
}
