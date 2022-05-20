import 'package:equatable/equatable.dart';

class Summary extends Equatable {
  double pheBudget;
  double phe;
  DateTime date;

  double breakfast;
  double lunch;
  double dinner;
  double snacks;

  Summary(this.date, this.phe, this.pheBudget,
      {this.breakfast = 0, this.dinner = 0, this.lunch = 0, this.snacks = 0});

  @override
  List<Object?> get props =>
      [date, phe, pheBudget, breakfast, lunch, dinner, snacks];
}
