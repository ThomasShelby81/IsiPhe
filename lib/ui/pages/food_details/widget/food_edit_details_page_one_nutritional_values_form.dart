import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isiphe/business/bloc/food_details_bloc/bloc/food_details_bloc.dart';
import 'package:isiphe/ui/icons/custom_icons_icons.dart';

class FootEditDetailsPageOneNutritionalValuesForm extends StatefulWidget {
  const FootEditDetailsPageOneNutritionalValuesForm({Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FootEditDetailsPageOneNutritionalValuesFormState();
  }
}

class _FootEditDetailsPageOneNutritionalValuesFormState
    extends State<FootEditDetailsPageOneNutritionalValuesForm> {
  late TextEditingController _proteinTextEditingController;
  late TextEditingController _fatTextEditingController;
  late TextEditingController _sugarTextEditingController;

  late FoodDetailsBloc _foodDetailsBloc;

  @override
  void initState() {
    super.initState();

    _foodDetailsBloc = BlocProvider.of<FoodDetailsBloc>(context);

    _proteinTextEditingController = TextEditingController();
    _fatTextEditingController = TextEditingController();
    _sugarTextEditingController = TextEditingController();

    _proteinTextEditingController.addListener(_onProteinChanged);
    _sugarTextEditingController.addListener(_onSugarChanged);
    _fatTextEditingController.addListener(_onFatChanged);

    if (_foodDetailsBloc.state.protein > 0) {
      _proteinTextEditingController.text =
          _foodDetailsBloc.state.protein.toString();
    }
    if (_foodDetailsBloc.state.sugar > 0) {
      _sugarTextEditingController.text =
          _foodDetailsBloc.state.sugar.toString();
    }
    if (_foodDetailsBloc.state.fat > 0) {
      _fatTextEditingController.text = _foodDetailsBloc.state.fat.toString();
    }
  }

  @override
  void dispose() {
    _fatTextEditingController.dispose();
    _sugarTextEditingController.dispose();
    _proteinTextEditingController.dispose();
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
                controller: _proteinTextEditingController,
                decoration: const InputDecoration(
                    icon: Icon(CustomIcons.protein), labelText: 'Eiweiß'),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.always,
                autocorrect: false,
                validator: (textValue) {
                  return !state.isProteinValid ? state.meldung : null;
                },
              ),
              TextFormField(
                controller: _fatTextEditingController,
                decoration: const InputDecoration(
                    icon: Icon(CustomIcons.fat), labelText: 'Fett'),
                keyboardType: TextInputType.number,
                validator: (_) {
                  return !state.isFatValid ? 'Fehlerhafte Eingabe' : null;
                },
              ),
              TextFormField(
                controller: _sugarTextEditingController,
                decoration: const InputDecoration(
                    icon: Icon(CustomIcons.sugar), labelText: 'Zucker'),
                keyboardType: TextInputType.number,
                validator: (_) {
                  return !state.isSugarValid ? 'Fehlerhafte Eingabe' : null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          )),
        );
      },
    );
  }

  void _onProteinChanged() {
    _foodDetailsBloc
        .add(FoodDetailsProteinChanged(_proteinTextEditingController.text));
  }

  void _onFatChanged() {
    _foodDetailsBloc.add(FoodDetailsFatChanged(_fatTextEditingController.text));
  }

  void _onSugarChanged() {
    _foodDetailsBloc
        .add(FoodDetailsSugarChanged(_sugarTextEditingController.text));
  }
}
