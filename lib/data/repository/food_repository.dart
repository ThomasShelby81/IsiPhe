import '../../model/food.dart';
import '../service/database_service.dart';

class FoodRepositoryImpl implements FoodRepository {
  final DatabaseService _databaseService;

  FoodRepositoryImpl(this._databaseService);

  @override
  Future<void> writeFood(Food food) {
    return _databaseService.writeFood(food);
  }
}

abstract class FoodRepository {
  Future<void> writeFood(Food food);
}
