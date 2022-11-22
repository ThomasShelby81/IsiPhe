import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:isiphe/extension/date_extension.dart';
import 'package:isiphe/model/data_point.dart';

import '../../../data/repository/meals_repository.dart';
import '../../../model/meal.dart';
import '../../../model/summary.dart';

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

    List<Meal> mealsPerDate = await _mealsRepository.readMealsPerDate(
        getLowerDate(newDate), getHigherDate(newDate));

    emit(CurrentDateBlocStateChanged(Summary(
        newDate,
        state.summary.proteinBudget,
        filterToDate(mealsPerDate, newDate),
        convertMealsToDataPoints(mealsPerDate, newDate))));
  }

  Future<FutureOr<void>> _onDecrement(
      DateDecrementedByOneDay event, Emitter<CurrentDateBlocState> emit) async {
    DateTime newDate = state.summary.date.subtract(const Duration(days: 1));

    registerListener(newDate);

    List<Meal> mealsPerDate = await _mealsRepository.readMealsPerDate(
        getLowerDate(newDate), getHigherDate(newDate));

    emit(CurrentDateBlocStateChanged(Summary(
        newDate,
        state.summary.proteinBudget,
        filterToDate(mealsPerDate, newDate),
        convertMealsToDataPoints(mealsPerDate, newDate))));
  }

  Future<FutureOr<void>> _onDateSelected(
      DateSelected event, Emitter<CurrentDateBlocState> emit) async {
    List<Meal> mealsPerDate = await _mealsRepository.readMealsPerDate(
        getLowerDate(event.newDate), getHigherDate(event.newDate));

    registerListener(event.newDate);

    emit(CurrentDateBlocStateChanged(Summary(
        event.newDate,
        state.summary.proteinBudget,
        filterToDate(mealsPerDate, event.newDate),
        convertMealsToDataPoints(mealsPerDate, event.newDate))));
  }

  Future<FutureOr<void>> onInitialDate(
      DateInitial event, Emitter<CurrentDateBlocState> emit) async {
    var state = CurrentDateBlocStateInitial();

    registerListener(state.summary.date);

    emit(state);
  }

  FutureOr<void> _onMealsPerDayChanged(
      MealsPerDayChanged event, Emitter<CurrentDateBlocState> emit) {
    emit(CurrentDateBlocStateChanged(Summary(
        event.date,
        state.summary.proteinBudget,
        filterToDate(event.mealsChanged, event.date),
        convertMealsToDataPoints(event.mealsChanged, event.date))));
  }

  registerListener(DateTime date) {
    _streamSubscription?.cancel();

    _streamSubscription = _mealsRepository
        .readMealsStreamPerDate(getLowerDate(date), getHigherDate(date))
        .listen((data) {
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

List<DataPoint> convertMealsToDataPoints(
    List<Meal> mealsPerDate, DateTime date) {
  List<DataPoint> result = [];

  DateTime currentDate = date;
  double value = 0.0;
  int day = 0;

  for (int i = 6; i > 0; i--) {
    currentDate = date.subtract(Duration(days: i));

    value = mealsPerDate
        .where((element) =>
            element.date.getDateOnly() == currentDate.getDateOnly())
        .fold(0.0, (previousValue, element) => previousValue + element.protein);

    result.add(DataPoint(day: ++day, value: value));
  }

  currentDate = date;

  for (int i = 0; i <= 3; i++) {
    currentDate = date.add(Duration(days: i));

    value = mealsPerDate
        .where((element) =>
            element.date.getDateOnly() == currentDate.getDateOnly())
        .fold(0.0, (previousValue, element) => previousValue + element.protein);
    result.add(DataPoint(day: ++day, value: value));
  }

  return result;
}

DateTime getLowerDate(DateTime date) {
  return date.subtract(const Duration(days: 7));
}

DateTime getHigherDate(DateTime date) {
  return date.add(const Duration(days: 3, hours: 23, minutes: 59, seconds: 59));
}

List<Meal> filterToDate(List<Meal> mealsPerDate, DateTime newDate) {
  List<Meal> meals = mealsPerDate
      .where((element) => element.date.getDateOnly() == newDate.getDateOnly())
      .toList();
  return meals;
}
