import 'package:flutter/foundation.dart';

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeLabelExtension on MealType {
  String get name => describeEnum(this);

  String get displayTitle {
    switch (this) {
      case MealType.breakfast:
        return 'Frühstück';
      case MealType.lunch:
        return 'Mittagessen';
      case MealType.snack:
        return 'Snack';
      case MealType.dinner:
        return 'Abendessen';
      default:
        return '';
    }
  }
}
