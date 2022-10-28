import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:isiphe/enum/meal_type.dart';

class Meal extends Equatable {
  final String id;
  final DateTime date;
  final double protein;
  final MealType mealType;

  const Meal(this.id, this.date, this.protein, this.mealType);

  @override
  List<Object?> get props => [date, protein, mealType];

  factory Meal.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options) {
    final data = snapshot.data();

    return Meal(snapshot.id, data?['date'].toDate(),
        data?['protein'].toDouble(), getMealTypeByValue(data?['type']));
  }

  Map<String, dynamic> toFirestore() {
    return {'date': date, 'protein': protein, 'type': mealType.name};
  }

  MealType getValueBy(String v) {
    for (MealType element in MealType.values) {
      if (element.name == v) {
        return element;
      }
    }
    return MealType.snack;
  }

  static getMealTypeByValue(value) {
    for (var v in MealType.values) {
      if (v.name == value) {
        return v;
      }
    }
    return MealType.breakfast;
  }
}
