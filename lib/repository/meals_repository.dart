import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/meal.dart';
import '../service/database_service.dart';

class MealsRepositoryImpl implements MealsRepository {
  final DatabaseService _databaseService;

  MealsRepositoryImpl(this._databaseService);

  @override
  Future<List<Meal>> readMealsPerDate(DateTime date) {
    return _databaseService.retrieveMealsPerDay(date.toString());
  }

  @override
  Stream<List<Meal>> readMealsStreamPerDate(DateTime date) {
    return _databaseService.retrieveStreamMealsPerDay(date);
  }

  @override
  Future<DocumentReference<Map<String, dynamic>>> writeMeal(Meal meal) {
    return _databaseService.writeMeal(meal);
  }
}

abstract class MealsRepository {
  Future<List<Meal>> readMealsPerDate(DateTime date);

  Stream<List<Meal>> readMealsStreamPerDate(DateTime date);

  Future<DocumentReference<Map<String, dynamic>>> writeMeal(Meal meal);
}
