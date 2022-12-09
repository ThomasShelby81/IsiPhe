import 'package:isiphe/model/food_type.dart';

import '../service/database_service.dart';

class FoodRepositoryImpl implements FoodRepository {
  final DatabaseService _databaseService;

  FoodRepositoryImpl(this._databaseService);

  @override
  Future<void> writeFood(FoodType foodType) {
    return _databaseService.writeFood(foodType);
  }

  @override
  Future<List<FoodType>> readFoods() {
    return _databaseService.readFoods();
  }

  @override
  Future<void> changeFavoriteProperty(FoodType foodType) {
    return _databaseService.changeFavoriteProperty(foodType);
  }

  @override
  Future<void> delete(FoodType foodType) {
    return _databaseService.delete(foodType);
  }
}

abstract class FoodRepository {
  Future<void> writeFood(FoodType foodType);

  Future<List<FoodType>> readFoods();

  Future<void> changeFavoriteProperty(FoodType foodType);

  Future<void> delete(FoodType foodType);
}
