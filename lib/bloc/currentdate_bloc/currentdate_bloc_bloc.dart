import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isiphe/extension/date_extension.dart';

import '../../model/meal.dart';
import '../../model/summary.dart';
import '../../repository/meals_repository.dart';

part 'currentdate_bloc_event.dart';
part 'currentdate_bloc_state.dart';

class CurrentDateBloc extends Bloc<CurrentDateBlocEvent, CurrentDateBlocState> {
  final MealsRepository _mealsRepository;

  StreamSubscription<List<Meal>>? _streamSubscription;

  CurrentDateBloc(this._mealsRepository)
      : super(CurrentDateBlocStateInitial()) {
    on<DateIncrementedByOneDay>(_onIncrement);
    on<DateDecrementedByOneDay>(_onDecrement);
    on<DateSelected>(_onDateSelected);
    on<DateInitial>(onInitialDate);
    on<MealsPerDayChanged>(_onMealsPerDayChanged);
  }

  Future<FutureOr<void>> _onIncrement(
      DateIncrementedByOneDay event, Emitter<CurrentDateBlocState> emit) async {
    DateTime newDate = state.summary.date.add(const Duration(days: 1));

    registerListener(newDate);

    List<Meal> mealsPerDate = await _mealsRepository.readMealsPerDate(newDate);

    emit(CurrentDateBlocStateChanged(
        Summary(newDate, state.summary.proteinBudget, mealsPerDate)));
  }

  Future<FutureOr<void>> _onDecrement(
      DateDecrementedByOneDay event, Emitter<CurrentDateBlocState> emit) async {
    DateTime newDate = state.summary.date.subtract(const Duration(days: 1));

    registerListener(newDate);

    List<Meal> mealsPerDate = await _mealsRepository.readMealsPerDate(newDate);

    emit(CurrentDateBlocStateChanged(
        Summary(newDate, state.summary.proteinBudget, mealsPerDate)));
  }

  Future<FutureOr<void>> _onDateSelected(
      DateSelected event, Emitter<CurrentDateBlocState> emit) async {
    List<Meal> mealsPerDate =
        await _mealsRepository.readMealsPerDate(event.newDate);

    registerListener(event.newDate);

    emit(CurrentDateBlocStateChanged(
        Summary(event.newDate, state.summary.proteinBudget, mealsPerDate)));
  }

  Future<FutureOr<void>> onInitialDate(
      DateInitial event, Emitter<CurrentDateBlocState> emit) async {
    var state = CurrentDateBlocStateInitial();

    registerListener(state.summary.date);

    emit(state);
  }

  FutureOr<void> _onMealsPerDayChanged(
      MealsPerDayChanged event, Emitter<CurrentDateBlocState> emit) {
    emit(CurrentDateBlocStateChanged(
        Summary(event.date, state.summary.proteinBudget, event.mealsChanged)));
  }

  registerListener(DateTime date) {
    _streamSubscription?.cancel();

    _streamSubscription =
        _mealsRepository.readMealsStreamPerDate(date).listen((data) {
      log(data.toString());
      add(MealsPerDayChanged(date, data));
    });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
