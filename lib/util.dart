import 'package:intl/intl.dart';

class LuminUtil {
  void main() {
    DateTime now = DateTime.now();
    String formattedDate = formatDate(now);
    print(formattedDate); // Output: "4th July, 2024 22:39:51.864"
  }

  static String formatDate(DateTime dateTime) {
    final day = dateTime.day;
    final daySuffix = getDaySuffix(day);
    final dateFormat = DateFormat("d'$daySuffix' MMMM, y HH:mm:ss.SSS");
    return dateFormat.format(dateTime);
  }

  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
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
}
