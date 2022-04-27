import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'currentdate_bloc_event.dart';
part 'currentdate_bloc_state.dart';

class CurrentDateBloc extends Bloc<CurrentDateBlocEvent, CurrentDateBlocState> {
  CurrentDateBloc() : super(CurrentDateBlocStateInitial()) {
    on<DateIncrementedByOneDay>(_onIncrement);
    on<DateDecrementedByOneDay>(_onDecrement);
    on<DateSelected>(_onDateSelected);
    on<DateInitial>(onInitialDate);
  }

  FutureOr<void> _onIncrement(
      DateIncrementedByOneDay event, Emitter<CurrentDateBlocState> emit) {
    emit(CurrentDateBlocStateChanged(state.date.add(const Duration(days: 1))));
  }

  FutureOr<void> _onDecrement(
      DateDecrementedByOneDay event, Emitter<CurrentDateBlocState> emit) {
    emit(CurrentDateBlocStateChanged(
        state.date.subtract(const Duration(days: 1))));
  }

  FutureOr<void> _onDateSelected(
      DateSelected event, Emitter<CurrentDateBlocState> emit) {
    emit(CurrentDateBlocStateChanged(event.newDate));
  }

  FutureOr<void> onInitialDate(
      DateInitial event, Emitter<CurrentDateBlocState> emit) {
    emit(CurrentDateBlocStateInitial());
  }
}
