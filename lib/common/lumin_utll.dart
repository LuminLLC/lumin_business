import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class LuminUtll {
  // Function to format a DateTime object to "8th August 2019"
  static String formatDate(DateTime date) {
    // Define the day suffix
    String _getDaySuffix(int day) {
      if (day >= 11 && day <= 13) return 'th';
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    // Get the day, month, and year from the DateTime object
    final day = date.day;
    final month = DateFormat('MMMM').format(date); // e.g., August
    final year = date.year;

    // Format the date without the time
    String output = '${day}${_getDaySuffix(day)} $month $year';
    print(output);
    return output;
  }

  String formatCurrency(double amount, {String currencyCode = "GHS"}) {
    final formatCurrency = NumberFormat.currency(
      locale: 'en_GH', // Assuming 'en_GH' locale for Ghana
      decimalDigits: 2, // Number of decimal places
    );
    return formatCurrency.format(amount);
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final String currencySymbol;

  CurrencyInputFormatter({this.currencySymbol = "GHS"});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value is empty, return the new value
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters
    String value = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // If there's nothing left after removing non-digit characters, return the old value
    if (value.isEmpty) {
      return oldValue;
    }

    // Parse the value to an integer
    int newValueAsInt = int.parse(value);

    // Format the number as currency
    final formatter = NumberFormat.currency(
      locale: 'en_GH',
      symbol: currencySymbol + " ",
      decimalDigits: 2,
    );

    // Apply the currency format
    String newText = formatter.format(newValueAsInt / 100);

    // Return the new TextEditingValue with the formatted currency string
    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
