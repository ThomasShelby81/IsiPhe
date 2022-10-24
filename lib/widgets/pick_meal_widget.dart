import 'package:flutter/material.dart';

import '../enum/meal_type.dart';

class PickMealWidget extends StatelessWidget {
  const PickMealWidget(
    MealType mealtype, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 35),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: const TabBar(tabs: [
              Tab(
                  icon: Icon(
                    Icons.search,
                  ),
                  text: 'Suche'),
              Tab(
                icon: Icon(Icons.scanner),
                text: 'Scan',
              ),
              Tab(
                icon: Icon(Icons.favorite),
                text: 'Favoriten',
              ),
            ]),
          ),
          body: SizedBox(
            height: 100,
            child: TabBarView(children: [
              Tab(
                child: GestureDetector(),
              ),
              const Icon(Icons.directions_transit),
              const Icon(Icons.directions_bike),
            ]),
          ),
        ),
      ),
    );
  }
}
