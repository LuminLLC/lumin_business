import 'dart:async';
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

  // Dynamic CSV Upload for Any Module
  static Future<List<T>> uploadFromCSV<T>(List<String> expectedHeaders,
      T Function(Map<String, dynamic>) mapToModel) async {
    // Create a file input element
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.accept = '.csv';
    uploadInput.click();

    Completer<List<T>> completer = Completer();
    uploadInput.onChange.listen((event) async {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = FileReader();
        reader.readAsText(file);
        reader.onLoadEnd.listen((event) {
          final content = reader.result as String;
          List<List<dynamic>> csvData =
              const CsvToListConverter().convert(content);

          if (csvData.isNotEmpty) {
            List<dynamic> fileHeaders = csvData.first;

            // Create a map of header positions
            Map<String, int> headerPositions = {};
            for (int i = 0; i < fileHeaders.length; i++) {
              headerPositions[fileHeaders[i].toString()] = i;
            }

            // Validate that the expected headers exist in the CSV
            for (String expectedHeader in expectedHeaders) {
              if (!headerPositions.containsKey(expectedHeader)) {
                print("Missing expected header: $expectedHeader");
                completer.completeError("Missing header: $expectedHeader");
                return;
              }
            }

            csvData.removeAt(0); // Remove headers from data

            // Map each row using dynamic header mapping
            List<T> dataList = csvData.map((row) {
              Map<String, dynamic> rowMap = {};
              for (String header in expectedHeaders) {
                rowMap[header] = row[headerPositions[header]!];
              }
              return mapToModel(rowMap);
            }).toList();

            completer.complete(dataList);
          }
        });
      }
    });

    return completer.future;
  }
}
