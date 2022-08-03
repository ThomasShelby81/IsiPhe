part of 'currentdate_bloc_bloc.dart';

abstract class CurrentDateBlocEvent extends Equatable {
  const CurrentDateBlocEvent();

  @override
  List<Object> get props => [];
}

class DateInitial extends CurrentDateBlocEvent {
  @override
  List<Object> get props => [];
}

class DateIncrementedByOneDay extends CurrentDateBlocEvent {
  @override
  List<Object> get props => [];
}

class DateDecrementedByOneDay extends CurrentDateBlocEvent {
  @override
  List<Object> get props => [];
}

class DateSelected extends CurrentDateBlocEvent {
  final DateTime newDate;

  const DateSelected(this.newDate);

  @override
  List<Object> get props => [newDate];
}
