import 'package:flutter/material.dart';

import 'food_edit_details_barcode_detector.dart';
import 'food_edit_details_page_one nutritional_values_form.dart';

class FoodEditDetailsPageOneNutritionalValues extends StatefulWidget {
  const FoodEditDetailsPageOneNutritionalValues({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditDetailsPageOneNutritionalValuesState();
  }
}

class _FoodEditDetailsPageOneNutritionalValuesState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        FoodEditDetailsBarCodeDetector(),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Schritt 1: Nährwerte'),
        ),
        FootEditDetailsPageOneNutritionalValuesForm(),
      ],
    );
  }
}
