import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/meal.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Meal>> retrieveMealsPerDay(String date) async {
    var querySnapshot = await _db.collection('meals').get();

    int day = DateTime.parse(date).day;
    int month = DateTime.parse(date).month;
    int year = DateTime.parse(date).year;

    List<Meal> meals = querySnapshot.docs
        .map((e) => Meal.fromDocumentSnapshot(e))
        .where((e) =>
            e.date.day == day && e.date.month == month && e.date.year == year)
        .toList();

    return meals;
  }
}
