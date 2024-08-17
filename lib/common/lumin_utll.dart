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
}
