import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:isiphe/data/repository/food_repository.dart';
import 'package:isiphe/model/enum/serving_size.dart';
import 'package:isiphe/model/serving_size.dart';
import 'package:optional/optional.dart';

import '../../../../model/food.dart';

part 'food_details_event.dart';
part 'food_details_state.dart';

class FoodDetailsBloc extends Bloc<FoodDetailsEvent, FoodDetailsState> {
  final FoodRepository _foodRepository;

  FoodDetailsBloc(this._foodRepository) : super(FoodDetailsState.initial()) {
    on<FoodDetailsFatChanged>(_foodDetailsFatChanged);
    on<FoodDetailsSugarChanged>(_foodDetailsSugarChanged);
    on<FoodDetailsProteinChanged>(_foodDetailsProteinChanged);
    on<FoodDetailsSaved>(_foodDetailsSaved);
    on<FoodDetailsBarcodeScanned>(_foodDetailsBarcodeScanned);
    on<FoodDetailsButtonNextPressed>(_foodDetailsButtonNextPressed);
    on<FoodDetailsNextPage>(_foodDetailsNextPage);
    on<FoodDetailsPreviousPage>(_foodDetailsPreviousPage);
    on<FoodDetailsFotoTaken>(_foodDetailsTaken);
    on<FoodDetailsPickFotoFailed>(_foodPickFotoFailed);
    on<FoodDetailsNameChanged>(_foodDetailsNameChanged);
    on<FoodDetailsVendorChanged>(_foodDetailsVendorChanged);
    on<FoodDetailsServingSizeSelected>(_foodDetailsServingSizeSelected);
    on<FoodDetailsServingSizeUnSelected>(_foodDetailsServingSizeUnselected);
  }

  FutureOr<void> _foodDetailsFatChanged(
      FoodDetailsFatChanged event, Emitter<FoodDetailsState> emit) {
    var valid = RegExp(r'\d{1,2},?\d{0,1}$').hasMatch(event.fat);

    emit(state.copyWith(
        isFatValid: valid,
        fat: valid ? NumberFormat().parse(event.fat).toDouble() : 0.0,
        meldung: valid ? '' : 'Fehlerhafte Eingabe'));
  }

  FutureOr<void> _foodDetailsSugarChanged(
      FoodDetailsSugarChanged event, Emitter<FoodDetailsState> emit) {
    var isValid = RegExp(r'\d{1,2},?\d{0,1}$').hasMatch(event.sugar);
    emit(state.copyWith(
        sugar: isValid ? NumberFormat().parse(event.sugar).toDouble() : 0.0,
        isSugarValid: isValid,
        meldung: isValid ? '' : 'Fehlerhafte Eingabe'));
  }

  FutureOr<void> _foodDetailsProteinChanged(
      FoodDetailsProteinChanged event, Emitter<FoodDetailsState> emit) {
    var isValid = RegExp(r'\d{1,2},?\d{0,1}$').hasMatch(event.protein);

    emit(state.copyWith(
        isProteinValid: isValid,
        protein: isValid ? NumberFormat().parse(event.protein).toDouble() : 0.0,
        meldung: isValid
            ? ''
            : event.protein == ''
                ? 'Pflichtfeld'
                : 'Fehlerhafte Eingabe'));
  }

  FutureOr<void> _foodDetailsNameChanged(
      FoodDetailsNameChanged event, Emitter<FoodDetailsState> emit) {
    emit(state.copyWith(name: event.name));
  }

  FutureOr<void> _foodDetailsVendorChanged(
      FoodDetailsVendorChanged event, Emitter<FoodDetailsState> emit) {
    emit(state.copyWith(vendor: event.vendor));
  }

  FutureOr<void> _foodDetailsBarcodeScanned(
      FoodDetailsBarcodeScanned event, Emitter<FoodDetailsState> emit) {
    emit(state.copyWith(barcode: event.data));
  }

  FutureOr<void> _foodDetailsNextPage(
      FoodDetailsNextPage event, Emitter<FoodDetailsState> emit) {
    if (event.page == event.page?.round().toDouble()) {
      emit(state.copyWith(page: state.page + 1));
    }
  }

  FutureOr<void> _foodDetailsPreviousPage(
      FoodDetailsPreviousPage event, Emitter<FoodDetailsState> emit) {
    if (event.page == event.page?.round().toDouble()) {
      emit(state.copyWith(page: state.page - 1));
    }
  }

  FutureOr<void> _foodDetailsTaken(
      FoodDetailsFotoTaken event, Emitter<FoodDetailsState> emit) {
    emit(state.copyWith(image: event.pickedFile));
  }

  FutureOr<void> _foodPickFotoFailed(
      FoodDetailsPickFotoFailed event, Emitter<FoodDetailsState> emit) {
    emit(state.copyWith(pickImageError: event.pickImageError));
  }

  FutureOr<void> _foodDetailsButtonNextPressed(
      FoodDetailsButtonNextPressed event, Emitter<FoodDetailsState> emit) {
    emit(state.gotoNextPage(state.page + 1));
  }

  FutureOr<void> _foodDetailsSaved(
      FoodDetailsSaved event, Emitter<FoodDetailsState> emit) {
    _foodRepository.writeFood(
      Food(
          protein: state.protein,
          fat: state.fat,
          sugar: state.sugar,
          barcode: state.barcode,
          name: state.name,
          image: state.imageFile,
          servingSizes: state.servingSizes,
          vendor: state.vendor),
    );
  }

  FutureOr<void> _foodDetailsServingSizeSelected(
      FoodDetailsServingSizeSelected event, Emitter<FoodDetailsState> emit) {
    if (event.gramm.isPresent) {
      emit(state.selectServingType(
          event.servingSize, Optional.of(double.parse(event.gramm.value))));
    } else {
      emit(state.selectServingType(event.servingSize, const Optional.empty()));
    }
  }

  FutureOr<void> _foodDetailsServingSizeUnselected(
      FoodDetailsServingSizeUnSelected event, Emitter<FoodDetailsState> emit) {
    emit(state.unselectServingType(event.servingSize));
  }
}
