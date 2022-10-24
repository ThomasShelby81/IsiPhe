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

  Meal fromJson(Map<String, dynamic> json) {
    return Meal(
        json['id'], json['date'], json['phe'], getValueBy(json['type']));
  }

  MealType getValueBy(String v) {
    for (MealType element in MealType.values) {
      if (element.name == v) {
        return element;
      }
    }
    return MealType.snack;
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'date': date, 'phe': protein, 'type': mealType.name};
  }

  Meal.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        date = DateTime.fromMicrosecondsSinceEpoch(
            doc.data()!['date'].microsecondsSinceEpoch),
        protein = doc.data()!['protein'].toDouble(),
        mealType = getMealTypeByValue(doc.data()!['type']);

  static getMealTypeByValue(value) {
    for (var v in MealType.values) {
      if (v.name == value) {
        return v;
      }
    }
    return MealType.breakfast;
  }
}
