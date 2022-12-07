import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional_internal.dart';

import '../../../business/bloc/meal_bloc/bloc/meal_bloc.dart';
import '../../../model/enum/meal_type.dart';
import '../../../model/meal.dart';

class PickMealWidget extends StatefulWidget {
  final DateTime currentDate;
  final MealType mealType;

  const PickMealWidget(
      {Key? key, required this.mealType, required this.currentDate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PickMealWidget();
  }
}

class _PickMealWidget extends State<PickMealWidget> {
  late TextEditingController _textEditingController;
  late MealType _dropDownValue;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _dropDownValue = MealType.snack;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.only(top: 35),
      child: DefaultTabController(
        length: 5,
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
                    Icons.abc,
                  ),
                  text: 'Protein'),
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
              Tab(
                icon: Icon(Icons.edit),
                text: 'Individuell',
              ),
            ]),
          ),
          body: SizedBox(
            height: 500,
            child: TabBarView(children: [
              Tab(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextField(
                                controller: _textEditingController,
                                maxLength: 3,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true, signed: false),
                                textInputAction: TextInputAction.done,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 50),
                                decoration: const InputDecoration(
                                  labelText: 'Phe',
                                  labelStyle: TextStyle(fontSize: 20),
                                  border: UnderlineInputBorder(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(widget.mealType.displayTitle,
                              style: const TextStyle(fontSize: 20))),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: FloatingActionButton.extended(
                            onPressed: () {
                              var bloc = context.read<MealBloc>();
                              bloc.add(MealEntered(Meal(
                                  '',
                                  widget.currentDate,
                                  double.parse(_textEditingController.text),
                                  Optional.ofNullable(widget.mealType)
                                      .orElse(_dropDownValue))));

                              Navigator.pop(context);
                            },
                            label: Row(
                              children: const [
                                Icon(Icons.save),
                                Text('Speichern')
                              ],
                            )),
                      )
                    ]),
              ),
              const Icon(Icons.directions_transit),
              const Icon(Icons.directions_bike),
              const Icon(Icons.directions_bike_outlined),
              const Icon(Icons.directions_bike_sharp),
            ]),
          ),
        ),
      ),
    );
  }
}
