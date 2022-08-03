import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/meal.dart';
import '../../model/summary.dart';
import '../../repository/meals_repository.dart';

part 'currentdate_bloc_event.dart';
part 'currentdate_bloc_state.dart';

class CurrentDateBloc extends Bloc<CurrentDateBlocEvent, CurrentDateBlocState> {
  final MealsRepository _mealsRepository;

  CurrentDateBloc(this._mealsRepository)
      : super(CurrentDateBlocStateInitial()) {
    on<DateIncrementedByOneDay>(_onIncrement);
    on<DateDecrementedByOneDay>(_onDecrement);
    on<DateSelected>(_onDateSelected);
    on<DateInitial>(onInitialDate);
  }

  Future<FutureOr<void>> _onIncrement(
      DateIncrementedByOneDay event, Emitter<CurrentDateBlocState> emit) async {
    DateTime newDate = state.summary.date.add(const Duration(days: 1));
    List<Meal> mealsPerDate = await _mealsRepository.readMealsPerDate(newDate);

    emit(CurrentDateBlocStateChanged(
        Summary(newDate, state.summary.proteinBudget, mealsPerDate)));
  }

  Future<FutureOr<void>> _onDecrement(
      DateDecrementedByOneDay event, Emitter<CurrentDateBlocState> emit) async {
    DateTime newDate = state.summary.date.subtract(const Duration(days: 1));
    List<Meal> mealsPerDate = await _mealsRepository.readMealsPerDate(newDate);

    emit(CurrentDateBlocStateChanged(
        Summary(newDate, state.summary.proteinBudget, mealsPerDate)));
  }

  Future<FutureOr<void>> _onDateSelected(
      DateSelected event, Emitter<CurrentDateBlocState> emit) async {
    List<Meal> mealsPerDate =
        await _mealsRepository.readMealsPerDate(event.newDate);

    emit(CurrentDateBlocStateChanged(
        Summary(event.newDate, state.summary.proteinBudget, mealsPerDate)));
  }

  FutureOr<void> onInitialDate(
      DateInitial event, Emitter<CurrentDateBlocState> emit) {
    emit(CurrentDateBlocStateInitial());
  }
}
