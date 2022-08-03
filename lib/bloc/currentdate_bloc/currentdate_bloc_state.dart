part of 'currentdate_bloc_bloc.dart';

abstract class CurrentDateBlocState extends Equatable {
  final Summary summary;

  const CurrentDateBlocState(this.summary);

  @override
  List<Object> get props => [summary];
}

class CurrentDateBlocStateInitial extends CurrentDateBlocState {
  CurrentDateBlocStateInitial()
      : super(Summary(DateTime.now(), 6, List.empty()));
}

class CurrentDateBlocStateChanged extends CurrentDateBlocState {
  const CurrentDateBlocStateChanged(Summary summary) : super(summary);
}
