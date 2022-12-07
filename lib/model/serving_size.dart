import 'package:isiphe/model/enum/serving_size.dart';
import 'package:optional/optional_internal.dart';

class ServingSize {
  final ServingSizeTypes servingSizeType;

  Optional<double> gramm;

  final String label;

  ServingSize(this.servingSizeType, this.label, this.gramm);
}
