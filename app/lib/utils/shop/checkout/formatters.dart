import 'package:flutter/services.dart';

class PostCodeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digitsOnly.length > 5) {
      digitsOnly = digitsOnly.substring(0, 5); // Limit to 5 digits
    }

    String formatted = '';
    if (digitsOnly.length >= 3) {
      formatted = '${digitsOnly.substring(0, 2)}-${digitsOnly.substring(2)}';
    } else if (digitsOnly.length >= 1) {
      formatted = digitsOnly;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 9) digits = digits.substring(0, 9);

    String formatted = '';
    for (int i = 0; i < digits.length; i++) {
      formatted += digits[i];
      if ((i == 2 || i == 5) && i != digits.length - 1) {
        formatted += ' ';
      }
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
