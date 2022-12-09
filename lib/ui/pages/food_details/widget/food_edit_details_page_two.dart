import 'package:flutter/material.dart';
import 'package:isiphe/ui/pages/food_details/widget/food_edit_details_page_two_form.dart';

import 'food_edit_details_page_two_serving_sizes.dart';

class FoodEditPageTwo extends StatefulWidget {
  const FoodEditPageTwo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditPageTwoState();
  }
}

class _FoodEditPageTwoState extends State {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Schritt 2: Lebensmitteldetails'),
        ),
        FoodEditDetailsPageTwoForm(),
        SizedBox(
          height: 10,
        ),
        FoodEditDetailsPageTwoServingSizes(),
      ],
    );
  }
}
