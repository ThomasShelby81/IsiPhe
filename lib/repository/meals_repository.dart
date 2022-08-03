import '../model/meal.dart';
import '../service/database_service.dart';

class MealsRepositoryImpl implements MealsRepository {
  final DatabaseService _databaseService;

  MealsRepositoryImpl(this._databaseService);

  @override
  Future<List<Meal>> readMealsPerDate(DateTime date) {
    return _databaseService.retrieveMealsPerDay(date.toString());
  }
}

abstract class MealsRepository {
  Future<List<Meal>> readMealsPerDate(DateTime date);
}