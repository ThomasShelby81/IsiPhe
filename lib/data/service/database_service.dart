import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isiphe/model/food.dart';

import '../../model/meal.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Meal>> retrieveMealsPerDay(
      DateTime lowerDate, DateTime higherDate) {
    Query<Map<String, dynamic>> query = _db
        .collection('meals')
        .where("date", isGreaterThanOrEqualTo: lowerDate)
        .where("date", isLessThanOrEqualTo: higherDate);

    return query.snapshots().first.then((value) => value.docs
        .map((e) => Meal.fromFirestore(e, SnapshotOptions()))
        .toList());
  }

  Stream<List<Meal>> retrieveStreamMealsPerDay(
      DateTime lowerDate, DateTime higherDate) {
    Query query = _db
        .collection('meals')
        .where("date", isGreaterThanOrEqualTo: lowerDate)
        .where("date", isLessThanOrEqualTo: higherDate);

    final Stream<QuerySnapshot> snapshots = query.snapshots();

    Stream<List<Meal>> stream = snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((element) => Meal.fromFirestore(
              element as DocumentSnapshot<Map<String, dynamic>>,
              SnapshotOptions()))
          .toList();
      return result;
    });

    return stream;
  }

  Future<DocumentReference<Map<String, dynamic>>> writeMeal(Meal meal) async {
    return await _db.collection('meals').add(meal.toFirestore());
  }

  Future<String> uploadImage(XFile image) async {
    final path = 'foods/${image.name}';
    final file = File(image.path);

    final ref = FirebaseStorage.instance.ref().child(path);
    final UploadTask uploadTask = ref.putFile(file);
    final snapshot = await uploadTask
        .whenComplete(() => {debugPrint('Upload Image $path complete.')});
    return snapshot.ref.getDownloadURL();
  }

  Future<DocumentReference<Map<String, dynamic>>> writeFood(Food food) async {
    String? imageUrl;
    if (food.image != null) {
      imageUrl = await uploadImage(food.image!);

      debugPrint('Uploaded URL for image ${food.image!.name} is $imageUrl.');
    }

    return await _db
        .collection('foods')
        .add(food.toFirestore(imageUrl: imageUrl ?? ''));
  }
}
