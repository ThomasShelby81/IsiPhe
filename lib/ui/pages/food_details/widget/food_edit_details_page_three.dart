import 'package:flutter/material.dart';
import 'package:isiphe/ui/pages/food_details/widget/food_edit_foto.dart';

class FoodEditDetailsPageThree extends StatefulWidget {
  const FoodEditDetailsPageThree({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditDetailsPageThreeState();
  }
}

class _FoodEditDetailsPageThreeState extends State<FoodEditDetailsPageThree> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Schritt 4: Foto'),
        ),
        FoodEditFoto()
      ],
    );
  }
}
