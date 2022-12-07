import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/meal.dart';
import '../service/database_service.dart';

class MealsRepositoryImpl implements MealsRepository {
  final DatabaseService _databaseService;

  MealsRepositoryImpl(this._databaseService);

  @override
  Future<List<Meal>> readMealsPerDate(DateTime lowerDate, DateTime higherDate) {
    return _databaseService.retrieveMealsPerDay(lowerDate, higherDate);
  }

  @override
  Stream<List<Meal>> readMealsStreamPerDate(
      DateTime lowerDate, DateTime higherDate) {
    return _databaseService.retrieveStreamMealsPerDay(lowerDate, higherDate);
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> writeMeal(Meal meal) {
    return _databaseService.writeMeal(meal);
  }
}

abstract class MealsRepository {
  Future<List<Meal>> readMealsPerDate(DateTime lowerDate, DateTime higherDate);

  Stream<List<Meal>> readMealsStreamPerDate(
      DateTime lowerDate, DateTime higherDate);

  Future<DocumentReference<Map<String, dynamic>>> writeMeal(Meal meal);
}
