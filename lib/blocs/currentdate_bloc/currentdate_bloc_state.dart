part of 'currentdate_bloc_bloc.dart';

abstract class CurrentDateBlocState extends Equatable {
  final DateTime date;

  const CurrentDateBlocState(this.date);

  @override
  List<Object> get props => [date];
}

class CurrentDateBlocStateInitial extends CurrentDateBlocState {
  CurrentDateBlocStateInitial() : super(DateTime.now());
}

class CurrentDateBlocStateChanged extends CurrentDateBlocState {
  const CurrentDateBlocStateChanged(DateTime date) : super(date);
}
