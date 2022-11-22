import 'package:flutter/services.dart';

class CustomMaxValueInputFormatter extends TextInputFormatter {
  final int maxDigits;
  final int maxDecimals;

  CustomMaxValueInputFormatter(this.maxDigits, this.maxDecimals);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regex = RegExp('^\\d{1,$maxDigits}\\.?\\d{0,$maxDecimals}');

    final String newString = regex.stringMatch(newValue.text) ?? '';

    return newString == newValue.text ? newValue : oldValue;
  }
}
