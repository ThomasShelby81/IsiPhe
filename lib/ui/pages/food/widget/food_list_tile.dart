import 'package:flutter_neumorphic_null_safety/flutter_neumorphic.dart';
import 'package:isiphe/model/food_type.dart';

typedef OnFoodSwitchFavorite = void Function(FoodType foodType);

typedef OnFoodDelete = void Function(FoodType foodType);

class FoodListTile extends StatelessWidget {
  final FoodType food;
  final OnFoodSwitchFavorite onFavoriteSwitched;
  final OnFoodDelete onDelete;

  const FoodListTile(this.food, this.onFavoriteSwitched, this.onDelete,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: Image.network(food.imageUrl).image,
      ), //Icon(Icons.list),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(value: 'edit', child: Text('Favorit')),
            const PopupMenuItem(value: 'delete', child: Text('Löschen'))
          ];
        },
        onSelected: onValueChanged,
      ),
      title: Text(
        food.name,
      ),
    );
  }

  void onValueChanged(String value) {
    switch (value) {
      case 'edit':
        onFavoriteSwitched(food);
        break;
      case 'delete':
        onDelete(food);
        break;
      default:
    }
  }
}
