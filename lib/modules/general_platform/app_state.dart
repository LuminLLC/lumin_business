import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumin_business/config.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:lumin_business/modules/user_and_busness/business_model.dart';
import 'package:lumin_business/modules/user_and_busness/lumin_user.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:provider/provider.dart';

class AppState with ChangeNotifier {
  final FirebaseFirestore _firestore = Config().firestoreEnv;
  String searchText = "";
  BusinessModel? businessInfo;
  LuminUser? user;
  int index = 0;

  Future<void> exportToExcel(List<ProductModel> products) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];

    // Adding header row
    sheetObject.appendRow([
      TextCellValue("ID"),
      TextCellValue("Name"),
      TextCellValue("Category"),
      TextCellValue("Quantity"),
      TextCellValue("Unit Price"),
      TextCellValue("Is Perishable"),
      TextCellValue("Expiry Date"),
    ]);

    // Adding data rows
    for (var product in products) {
      sheetObject.appendRow([
        TextCellValue(product.id ?? 'N/A'),
        TextCellValue(product.name),
        TextCellValue(product.category),
        IntCellValue(product.quantity),
        DoubleCellValue(product.unitPrice),
        BoolCellValue(product.isPerishable),
        TextCellValue(product.isPerishable && product.expiryDate != null
            ? product.expiryDate.toString()
            : 'N/A')
      ]);
    }

    String outputFile = "/Users/kawal/Desktop/git_projects/r.xlsx";

    //stopwatch.reset();
    List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    // if (fileBytes != null) {
    //   File(outputFile)
    //     ..createSync(recursive: true)
    //     ..writeAsBytesSync(fileBytes);
    // }
    // try {
    //   // Save the file to the device
    //   Directory? directory = await getExternalStorageDirectory();
    //   String outputFile = directory!.path + 'Products.xlsx';

    //   List<int>? fileBytes = excel.save();
    //   if (fileBytes != null) {
    //     File(outputFile)
    //       ..createSync(recursive: true)
    //       ..writeAsBytesSync(fileBytes);
    //   }
    // } on Exception catch (e) {
    //   print(e);
    // }
  }

  Future<void> createPdfAndDownload(List<String> items) async {
    final pdf = pw.Document();

    // Load the custom DM Sans font
    final fontData =
        await rootBundle.load('assets/fonts/DMSans-VariableFont_opsz,wght.ttf');
    final ttf = pw.Font.ttf(fontData);

    const int itemsPerPage = 5;

    // Generate pages based on itemsPerPage
    for (int i = 0; i < items.length; i += itemsPerPage) {
      final sublist = items.skip(i).take(itemsPerPage).toList();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              children: sublist
                  .map((item) => pw.Text(item, style: pw.TextStyle(font: ttf)))
                  .toList(),
            );
          },
        ),
      );
    }

    // Save and print the PDF
    Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  void setSearchText(newText) {
    searchText = newText;
    notifyListeners();
  }

  void setIndex(int i) {
    if (index != i) {
      setSearchText("");
      index = i;
      notifyListeners();
    }
  }

  Future<void> fetchBusiness(String businessID) async {
    if (businessInfo == null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> temp =
            await _firestore.collection('businesses').doc(businessID).get();

        businessInfo = BusinessModel(
          businessId: temp.id,
          businessName: temp.data()!['business_name'],
          businessLogo: temp.data()!['business_logo'] ?? "",
          adminEmail: temp.data()!['email'],
          businessAddress: temp.data()!['location'],
          contactNumber: temp.data()!['contact_number'],
          businessType: temp.data()!['business_type'],
          businessDescription: temp.data()!['description'],
          accounts: temp.data()!['accounts'],
        );

        print({businessInfo!.accounts});
        user!.access = businessInfo!.accounts[user!.email];
        notifyListeners();
      } catch (e) {}
    }
  }

  fetchUser(BuildContext context) async {
    if (user == null) {
      print("fetch user");
      DocumentSnapshot<Map<String, dynamic>> temp = await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      Provider.of<InventoryProvider>(context, listen: false)
          .fetchProducts(temp.data()!['business_id']);
      user = LuminUser(
        id: temp.id,
        email: temp.data()!['email'],
        name: temp.data()!['name'],
        businessId: temp.data()!['business_id'],
      );

      fetchBusiness(user!.businessId);
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    user = null;
    businessInfo = null;
    notifyListeners();
  }
}
