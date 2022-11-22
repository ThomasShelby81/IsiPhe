import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:isiphe/business/bloc/currentdate_bloc/currentdate_bloc_bloc.dart';
import 'package:isiphe/business/bloc/meal_bloc/bloc/meal_bloc.dart';
import 'package:isiphe/data/repository/meals_repository.dart';
import 'package:isiphe/model/enum/meal_type.dart';
import 'package:isiphe/ui/routes/widgets/pick_meal_widget.dart';

class MealTypeActionButton extends StatefulWidget {
  final MealsRepository mealsRepository;

  const MealTypeActionButton({Key? key, required this.mealsRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MealTypeActionButton();
  }
}

class _MealTypeActionButton extends State<MealTypeActionButton> {
  final _isDialogOpen = ValueNotifier<bool>(false);

  final _customDialRoot = false;
  final _extend = false;
  final _visible = true;
  final _switchLabelPosition = false;
  final _closeManually = false;
  final _renderOverlay = true;
  final _useAnimation = true;
  var _rmIcons = false;

  final _speedDialDirection = SpeedDialDirection.up;

  final _buttonSize = const Size(56, 56);
  final _childrenButtonSize = const Size(56, 56);

  final List<MealTypeDialOption> _options = [
    MealTypeDialOption(
        label: 'Frühstück',
        icon: const Icon(Icons.breakfast_dining),
        mealType: MealType.breakfast),
    MealTypeDialOption(
        label: 'Mittagessen',
        icon: const Icon(Icons.lunch_dining),
        mealType: MealType.lunch),
    MealTypeDialOption(
        label: 'Abendessen',
        icon: const Icon(Icons.dining),
        mealType: MealType.dinner),
    MealTypeDialOption(
        label: 'Snack', icon: const Icon(Icons.add), mealType: MealType.snack)
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentDateBloc, CurrentDateBlocState>(
      builder: (context, state) {
        return SpeedDial(
          backgroundColor: Colors.blue,
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: _isDialogOpen,
          childPadding: const EdgeInsets.all(5),
          dialRoot: _customDialRoot
              ? (context, open, toggleChildren) {
                  return ElevatedButton(
                    onPressed: toggleChildren,
                    child: const Text(
                      'Custom Dial Root',
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                }
              : null,
          buttonSize: _buttonSize,
          // The label of the main button.
          /// The active label of the main button, Defaults to label if not specified.
          label: _extend ? const Text('Open') : null,

          /// The below button size defaults to 56 itself, its the SpeedDial childrens size
          childrenButtonSize: _childrenButtonSize,
          visible: _visible,
          direction: _speedDialDirection,
          switchLabelPosition: _switchLabelPosition,

          /// If true user is forced to close dial manually
          closeManually: _closeManually,

          /// If false, backgroundOverlay will not be rendered.
          renderOverlay: _renderOverlay,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,

          onOpen: () => debugPrint('Opening Dial'),
          onClose: () => debugPrint('Closing Dial'),

          useRotationAnimation: _useAnimation,

          tooltip: 'Öffne Schnellerfassung für Mahlzeiten',
          heroTag: 'Schnellerfassung-Mahlzeiten',

          elevation: 8.0,
          isOpenOnStart: false,
          animationSpeed: 200,
          shape: _customDialRoot
              ? const RoundedRectangleBorder()
              : const StadiumBorder(),

          children: _buildSpeedDialChildren(_options, state.summary.date),
        );
      },
    );
  }

  Widget _buildMealPickerWidget(var c, MealType mealType,
      MealsRepository mealsRepository, DateTime currentDate) {
    return BlocProvider(
      create: (c) => MealBloc(mealsRepository),
      child: PickMealWidget(
        mealType: mealType,
        currentDate: currentDate,
      ),
    );
  }

  List<SpeedDialChild> _buildSpeedDialChildren(
      List<MealTypeDialOption> options, DateTime currentDate) {
    return _options
        .map((o) => SpeedDialChild(
            child: !_rmIcons ? o.icon : null,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            label: o.label,
            onTap: () {
              _rmIcons = !_rmIcons;
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: true,
                elevation: 10,
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                builder: (c) {
                  return _buildMealPickerWidget(
                      c, o.mealType, widget.mealsRepository, currentDate);
                },
              );
            }))
        .toList();
  }
}

class MealTypeDialOption {
  final MealType mealType;
  final String label;
  final Icon icon;

  MealTypeDialOption(
      {required this.mealType, required this.label, required this.icon});
}
