part of 'food_details_bloc.dart';

class FoodDetailsState extends Equatable {
  final bool isProteinValid;
  final bool isFatValid;
  final bool isSugarValid;

  final double protein;
  final double sugar;
  final double fat;

  final String name;
  final String vendor;

  final String barcode;
  final String meldung;
  final int page;
  final bool forceJumpToPage;
  final XFile? imageFile;
  final dynamic pickImageError;
  final List<ServingSize> servingSizes;
  final List<ServingSize> servingSizesSelected;

  const FoodDetailsState(
      {required this.isFatValid,
      required this.isProteinValid,
      required this.isSugarValid,
      this.protein = 0.0,
      this.sugar = 0.0,
      this.fat = 0.0,
      this.barcode = '',
      this.name = '',
      this.vendor = '',
      this.meldung = '',
      this.page = 0,
      this.forceJumpToPage = false,
      this.imageFile,
      this.pickImageError,
      required this.servingSizes,
      required this.servingSizesSelected});

  factory FoodDetailsState.initial() {
    return FoodDetailsState(
        isFatValid: true,
        isProteinValid: false,
        isSugarValid: true,
        servingSizes: [
          ServingSize(ServingSizeTypes.gramm, "Gramm", const Optional.empty()),
          ServingSize(ServingSizeTypes.milliliter, "Millilitter",
              const Optional.empty()),
          ServingSize(ServingSizeTypes.piece, "Stück", Optional.of(0.0)),
          ServingSize(ServingSizeTypes.slice, "Scheibe", Optional.of(0.0)),
          ServingSize(ServingSizeTypes.litlePortion, "kleine Portion",
              Optional.of(0.0)),
          ServingSize(
              ServingSizeTypes.bigPortion, "große Portion", Optional.of(0.0))
        ],
        servingSizesSelected: List.empty(growable: true));
  }

  FoodDetailsState gotoNextPage(int page) {
    return copyWith(page: page, forceJumpToPage: true);
  }

  FoodDetailsState copyWith(
      {bool? isFatValid,
      bool? isSugarValid,
      bool? isProteinValid,
      String? meldung,
      double? fat,
      double? sugar,
      double? protein,
      String? barcode,
      String? name,
      String? vendor,
      XFile? image,
      dynamic pickImageError,
      int? page,
      bool? forceJumpToPage}) {
    return FoodDetailsState(
        fat: fat ?? this.fat,
        sugar: sugar ?? this.sugar,
        protein: protein ?? this.protein,
        isFatValid: isFatValid ?? this.isFatValid,
        isProteinValid: isProteinValid ?? this.isProteinValid,
        isSugarValid: isSugarValid ?? this.isSugarValid,
        meldung: meldung ?? this.meldung,
        barcode: barcode ?? this.barcode,
        name: name ?? this.name,
        vendor: vendor ?? this.vendor,
        imageFile: image ?? imageFile,
        pickImageError: pickImageError ?? this.pickImageError,
        page: page ?? this.page,
        forceJumpToPage: forceJumpToPage ?? false,
        servingSizes: servingSizes,
        servingSizesSelected: servingSizesSelected);
  }

  FoodDetailsState selectServingType(
      ServingSizeTypes servingSizeType, Optional<double> gramm) {
    var newState = copyWith();

    var servingSize = newState.getByType(servingSizeType);
    servingSize.gramm = gramm;

    newState.servingSizesSelected.add(servingSize);
    return newState;
  }

  FoodDetailsState unselectServingType(ServingSizeTypes servingSizeType) {
    var newState = copyWith();
    var servingSize = newState.getByType(servingSizeType);
    if (servingSize.gramm.isPresent) {
      servingSize.gramm = Optional.of(0.0);
    }
    newState.servingSizesSelected.remove(getByType(servingSizeType));
    return newState;
  }

  ServingSize getByType(ServingSizeTypes servingSize) {
    return servingSizes
        .where((element) => element.servingSizeType == servingSize)
        .first;
  }

  @override
  List<Object> get props {
    List<Object> result = [
      isProteinValid,
      isFatValid,
      isSugarValid,
      protein,
      sugar,
      fat,
      barcode,
      name,
      vendor,
      meldung,
      page,
      forceJumpToPage,
      servingSizes,
      servingSizesSelected
    ];
    if (imageFile != null) {
      result.add(imageFile!);
    }
    if (pickImageError != null) {
      result.add(pickImageError);
    }
    return result;
  }
}
