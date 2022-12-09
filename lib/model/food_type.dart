import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isiphe/model/serving_size.dart';

class FoodType extends Equatable {
  final String id;
  bool favorite = false;

  final double protein;
  final double fat;
  final double sugar;

  final String barcode;
  final String name;
  final String vendor;

  final XFile? image;

  final String imageUrl;

  final List<ServingSize> servingSizes;

  FoodType(
      {this.id = '',
      required this.protein,
      this.fat = 0.0,
      this.sugar = 0.0,
      this.name = '',
      this.vendor = '',
      this.barcode = '',
      this.servingSizes = const [],
      this.image,
      this.imageUrl = '',
      this.favorite = false});

  factory FoodType.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final data = snapshot.data();

    return FoodType(
      id: snapshot.id,
      protein: data?['protein'],
      fat: data?['fat'],
      sugar: data?['sugar'],
      barcode: data?['barcode'],
      name: data?['name'],
      vendor: data?['vendor'],
      imageUrl: data?['imageUrl'],
      favorite: data?['favorite'] ?? false,
      servingSizes: extractMealTypes(data?['servingsizes'], options),
    );
  }

  Map<String, dynamic> toFirestore({String imageUrl = ''}) {
    var json = {
      'protein': protein,
      'fat': fat,
      'sugar': sugar,
      'barcode': barcode,
      'name': name,
      'vendor': vendor,
      'imageUrl': imageUrl,
      'favorite': favorite,
      'servingsizes': servingSizes.map((e) => e.toFirestore()).toList(),
    };

    return json;
  }

  static List<ServingSize> extractMealTypes(
      List<dynamic> data, SnapshotOptions options) {
    return data.map((e) {
      Map<String, dynamic> values = e;
      return ServingSize.fromFirestore(values, options);
    }).toList();
  }

  @override
  List<Object?> get props => [
        id,
        protein,
        fat,
        sugar,
        name,
        vendor,
        barcode,
        imageUrl,
        servingSizes,
        favorite
      ];

  FoodType copyWith({required bool favorite}) {
    return FoodType(
        protein: protein,
        fat: fat,
        sugar: sugar,
        barcode: barcode,
        id: id,
        image: image,
        imageUrl: imageUrl,
        name: name,
        servingSizes: servingSizes,
        vendor: vendor,
        favorite: favorite);
  }
}
