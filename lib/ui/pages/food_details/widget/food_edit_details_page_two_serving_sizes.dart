import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:optional/optional.dart';

import '../../../../business/bloc/food_details_bloc/bloc/food_details_bloc.dart';
import '../../../../business/utils/custom_max_value_input_formatter.dart';
import '../../../../model/enum/serving_size.dart';
import '../../../../model/serving_size.dart';

class FoodEditDetailsPageTwoServingSizes extends StatefulWidget {
  const FoodEditDetailsPageTwoServingSizes({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditDetailsPageTwoServingSizesState();
  }
}

class _FoodEditDetailsPageTwoServingSizesState
    extends State<FoodEditDetailsPageTwoServingSizes> {
  late TextEditingController _popupDialogTextController;

  late FoodDetailsBloc _foodDetailsBloc;

  @override
  void initState() {
    super.initState();

    _foodDetailsBloc = BlocProvider.of<FoodDetailsBloc>(context);

    _popupDialogTextController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Schritt 3: Serviergrößen'),
            SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Wrap(spacing: 5, children: [
                  _buildChipOption(state, ServingSizeTypes.gramm),
                  _buildChipOption(state, ServingSizeTypes.milliliter),
                  _buildChipOption(state, ServingSizeTypes.piece),
                  _buildChipOption(state, ServingSizeTypes.slice),
                  _buildChipOption(state, ServingSizeTypes.litlePortion),
                  _buildChipOption(state, ServingSizeTypes.bigPortion),
                ]))
          ],
        ),
      );
    });
  }

  Widget _buildChipOption(
      FoodDetailsState state, ServingSizeTypes servingSizeType) {
    ServingSize? currentServingSize = state.getByType(servingSizeType);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
        builder: (context, state) {
          return FilterChip(
            label: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(currentServingSize.label),
                if (currentServingSize.gramm.isPresent)
                  Text(
                    ' (${currentServingSize.gramm.value}g)',
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w400),
                  )
              ],
            ),
            backgroundColor: Colors.tealAccent[200],
            avatar: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.medication_liquid),
            ),
            selected: state.servingSizesSelected.contains(currentServingSize),
            selectedColor: Colors.blue,
            onSelected: (value) async {
              if (value) {
                if (currentServingSize.gramm.isPresent) {
                  String? valueGramm =
                      await openDialog(currentServingSize.label);
                  if (valueGramm != null) {
                    setState(() {
                      _foodDetailsBloc.add(FoodDetailsServingSizeSelected(
                          servingSize: servingSizeType,
                          gramm: Optional.of(valueGramm)));
                    });
                  }
                } else {
                  setState(() {
                    _foodDetailsBloc.add(FoodDetailsServingSizeSelected(
                        servingSize: servingSizeType));
                  });
                }
              } else {
                setState(() {
                  _foodDetailsBloc
                      .add(FoodDetailsServingSizeUnSelected(servingSizeType));
                });
              }
            },
          );
        },
      ),
    );
  }

  Future<String?> openDialog(
    String labelServiergroesse,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Bitte erfasse die Gramm pro $labelServiergroesse'),
            content: TextField(
              decoration:
                  InputDecoration(hintText: 'Gramm pro $labelServiergroesse'),
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.right,
              inputFormatters: [CustomMaxValueInputFormatter(2, 1)],
              controller: _popupDialogTextController,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(_popupDialogTextController.text);
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }
}
