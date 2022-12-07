part of 'food_details_bloc.dart';

abstract class FoodDetailsEvent extends Equatable {
  const FoodDetailsEvent();

  @override
  List<Object> get props => [];
}

class FoodDetailsProteinChanged extends FoodDetailsEvent {
  final String protein;

  const FoodDetailsProteinChanged(this.protein);

  @override
  List<Object> get props => [protein];
}

class FoodDetailsFatChanged extends FoodDetailsEvent {
  final String fat;

  const FoodDetailsFatChanged(this.fat);

  @override
  List<Object> get props => [fat];
}

class FoodDetailsSugarChanged extends FoodDetailsEvent {
  final String sugar;

  const FoodDetailsSugarChanged(this.sugar);

  @override
  List<Object> get props => [sugar];
}

class FoodDetailsSaved extends FoodDetailsEvent {
  @override
  List<Object> get props => [];
}

class FoodDetailsBarcodeScanned extends FoodDetailsEvent {
  final String data;

  const FoodDetailsBarcodeScanned(this.data);

  @override
  List<Object> get props => [data];
}

class FoodDetailsButtonNextPressed extends FoodDetailsEvent {
  const FoodDetailsButtonNextPressed();

  @override
  List<Object> get props => [];
}

class FoodDetailsNextPage extends FoodDetailsEvent {
  final double? page;
  const FoodDetailsNextPage(this.page);

  @override
  List<Object> get props => [page ?? 0];
}

class FoodDetailsPreviousPage extends FoodDetailsEvent {
  final double? page;
  const FoodDetailsPreviousPage(this.page);

  @override
  List<Object> get props => [page ?? 0];
}

class FoodDetailsFotoTaken extends FoodDetailsEvent {
  final XFile? pickedFile;

  const FoodDetailsFotoTaken(this.pickedFile);

  @override
  List<Object> get props => [pickedFile!];
}

class FoodDetailsPickFotoFailed extends FoodDetailsEvent {
  final dynamic pickImageError;

  const FoodDetailsPickFotoFailed(this.pickImageError);

  @override
  List<Object> get props => [pickImageError];
}

class FoodDetailsNameChanged extends FoodDetailsEvent {
  final String name;

  const FoodDetailsNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

class FoodDetailsVendorChanged extends FoodDetailsEvent {
  final String vendor;

  const FoodDetailsVendorChanged(this.vendor);

  @override
  List<Object> get props => [vendor];
}

class FoodDetailsServingSizeSelected extends FoodDetailsEvent {
  final ServingSizeTypes servingSize;
  final Optional<String> gramm;

  const FoodDetailsServingSizeSelected(
      {required this.servingSize, this.gramm = const Optional.empty()});

  @override
  List<Object> get props => [servingSize];
}

class FoodDetailsServingSizeUnSelected extends FoodDetailsEvent {
  final ServingSizeTypes servingSize;

  const FoodDetailsServingSizeUnSelected(this.servingSize);

  @override
  List<Object> get props => [servingSize];
}
