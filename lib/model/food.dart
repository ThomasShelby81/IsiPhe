import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isiphe/model/serving_size.dart';

class Food {
  final double protein;
  final double fat;
  final double sugar;

  final String barcode;
  final String name;
  final String vendor;

  final XFile? image;

  final List<ServingSize> servingSizes;

  Food(
      {required this.protein,
      this.fat = 0.0,
      this.sugar = 0.0,
      this.name = '',
      this.vendor = '',
      this.barcode = '',
      this.servingSizes = const [],
      this.image});

  factory Food.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions options) {
    final data = snapshot.data();

    return Food(
        protein: double.parse(data?['protein']),
        fat: double.parse(data?['fat']),
        sugar: double.parse(data?['sugar']),
        barcode: data?['barcode'],
        name: data?['name'],
        vendor: data?['vendor'],
        servingSizes: extractMealTypes(data?['serving_sizes']),
        image: getImage(data?['image']));
  }

  Map<String, dynamic> toFirestore({String imageUrl = ''}) {
    return {
      'protein': protein,
      'fat': fat,
      'sugar': sugar,
      'barcode': barcode,
      'name': name,
      'vendor': vendor,
      'imageUrl': imageUrl
    };
  }

  static List<ServingSize> extractMealTypes(Map<String, dynamic> data) {
    return [];
  }

  static getImage(data) {}
}
