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
        .map((e) => Meal.fromFirestore(e, SnapshotOptions()))
        .where((e) =>
            e.date.day == day && e.date.month == month && e.date.year == year)
        .toList();

    return meals;
  }

  Stream<List<Meal>> retrieveStreamMealsPerDay(DateTime date) {
    DateTime fromDate = date;
    DateTime toDate =
        date.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    date = date.subtract(const Duration(days: 1));
    Query query = _db
        .collection('meals')
        .where("date", isGreaterThanOrEqualTo: fromDate)
        .where("date", isLessThanOrEqualTo: toDate);

    final Stream<QuerySnapshot> snapshots = query.snapshots();

    Stream<List<Meal>> stream = snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((element) => Meal.fromFirestore(
              element as DocumentSnapshot<Map<String, dynamic>>,
              SnapshotOptions()))
          .toList();
      return result;
    });

    return stream;
  }

  Future<DocumentReference<Map<String, dynamic>>> writeMeal(Meal meal) async {
    return await _db.collection('meals').add(meal.toFirestore());
  }
}
