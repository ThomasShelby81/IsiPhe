import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business/bloc/food_details_bloc/bloc/food_details_bloc.dart';

class FoodEditDetailsPageTwoForm extends StatefulWidget {
  const FoodEditDetailsPageTwoForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FoodEditDetailsPageTwoFormState();
  }
}

class _FoodEditDetailsPageTwoFormState
    extends State<FoodEditDetailsPageTwoForm> {
  late TextEditingController _foodNameTextController;
  late TextEditingController _foodVendorTextController;

  late FoodDetailsBloc _foodDetailsBloc;

  @override
  void initState() {
    super.initState();

    _foodDetailsBloc = BlocProvider.of<FoodDetailsBloc>(context);

    _foodNameTextController = TextEditingController();
    _foodVendorTextController = TextEditingController();

    _foodNameTextController.addListener(_onNameChanged);
    _foodVendorTextController.addListener(_onVendorChanged);

    if (_foodDetailsBloc.state.name.isNotEmpty) {
      _foodNameTextController.text = _foodDetailsBloc.state.name;
    }
    if (_foodDetailsBloc.state.vendor.isNotEmpty) {
      _foodVendorTextController.text = _foodDetailsBloc.state.vendor;
    }
  }

  @override
  void dispose() {
    _foodNameTextController.dispose();
    _foodVendorTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodDetailsBloc, FoodDetailsState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
            child: Column(
          children: [
            TextFormField(
              controller: _foodNameTextController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.abc), labelText: 'Name'),
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.always,
              autocorrect: false,
              maxLength: 15,
            ),
            TextFormField(
              controller: _foodVendorTextController,
              decoration: const InputDecoration(
                  icon: Icon(Icons.business_center), labelText: 'Hersteller'),
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.always,
              autocorrect: false,
              maxLength: 30,
            )
          ],
        )),
      );
    });
  }

  void _onNameChanged() {
    _foodDetailsBloc.add(FoodDetailsNameChanged(_foodNameTextController.text));
  }

  void _onVendorChanged() {
    _foodDetailsBloc
        .add(FoodDetailsVendorChanged(_foodVendorTextController.text));
  }
}
