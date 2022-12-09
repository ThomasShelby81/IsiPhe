import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:isiphe/model/enum/serving_size.dart';
import 'package:optional/optional_internal.dart';

class ServingSize extends Equatable {
  final ServingSizeTypes servingSizeType;

  Optional<double> gramm;

  final String label;

  ServingSize(this.servingSizeType, this.label, this.gramm);

  Map<String, dynamic> toFirestore() {
    return {
      'type': servingSizeType.name,
      'gramm': gramm.orElse(0.0),
      'label': label,
    };
  }

  factory ServingSize.fromFirestore(
      Map<String, dynamic> data, SnapshotOptions options) {
    return ServingSize(getTypeByString(data['type']), data['label'],
        Optional.of(data['gramm']));
  }

  static ServingSizeTypes getTypeByString(String value) {
    return ServingSizeTypes.values
        .firstWhere((element) => element.name == value);
  }

  @override
  List<Object?> get props => [servingSizeType, gramm, label];
}
