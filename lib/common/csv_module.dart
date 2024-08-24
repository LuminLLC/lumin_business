import 'dart:convert';
import 'dart:html';
import 'package:csv/csv.dart';
import 'package:lumin_business/common/lumin_utll.dart';

class CSVModule {
  // Generic function to download data of any type to CSV
  static void downloadToCSV<T>(List<T> data, List<String> headers,
      List<dynamic> Function(T) rowBuilder, String fileName) {
    // Create rows, starting with headers
    List<List<dynamic>> rows = [headers];

    // Add each data item to the rows using the provided rowBuilder
    for (var item in data) {
      rows.add(rowBuilder(item));
    }

    // Convert rows to CSV string
    String csvData = const ListToCsvConverter().convert(rows);

    // Create a Blob and trigger a download
    final bytes = utf8.encode(csvData);
    final blob = Blob([bytes]);

    final url = Url.createObjectUrlFromBlob(blob);
    AnchorElement(href: url)
      ..setAttribute(
          "download", "${fileName}_${LuminUtll.formatDate(DateTime.now())}.csv")
      ..click();

    Url.revokeObjectUrl(url); // Clean up the URL after download
  }
}
