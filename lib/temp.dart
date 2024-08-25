import 'package:flutter/material.dart';
import 'package:lumin_business/common/csv_module.dart';
import 'package:lumin_business/modules/accounting/accounting_model.dart';
import 'package:lumin_business/modules/customers/customer_model.dart';
import 'package:lumin_business/modules/inventory/product_model.dart';
import 'package:lumin_business/modules/suppliers/supplier_model.dart';

class Temp extends StatefulWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  State<Temp> createState() => _TempState();
}

class _TempState extends State<Temp> {
  void uploadTransactionsFromCSV() async {
    List<String> transactionHeaders = [
      "id",
      "description",
      "amount",
      "date",
      "type",
      "saleID",
      "purchaseOrderID"
    ];

    try {
      List<AccountingModel> transactions =
          await CSVModule.uploadFromCSV<AccountingModel>(
        transactionHeaders,
        (rowMap) => AccountingModel.fromMap(rowMap),
      );
      print("Transactions uploaded: ${transactions.length}");
    } catch (e) {
      print("Error uploading transactions: $e");
    }
  }

  void uploadSuppliersFromCSV() async {
    List<String> supplierHeaders = [
      "id",
      "name",
      "contactNumber",
      "email",
      "address"
    ];

    try {
      List<SupplierModel> suppliers =
          await CSVModule.uploadFromCSV<SupplierModel>(
        supplierHeaders,
        (rowMap) => SupplierModel.fromMap(rowMap),
      );
      print("Suppliers uploaded: ${suppliers.length}");
    } catch (e) {
      print("Error uploading suppliers: $e");
    }
  }

  void uploadProductsFromCSV() async {
    List<String> productHeaders = [
      "ID",
      "Name",
      "Category",
      "Quantity",
      "Unit Price",
      
    ];

    try {
      List<ProductModel> products = await CSVModule.uploadFromCSV<ProductModel>(
        productHeaders,
        (rowMap) => ProductModel.fromMap(rowMap),
      );
      print("Products uploaded: ${products.length}");
    } catch (e) {
      print("Error uploading products: $e");
    }
  }

  void uploadCustomersFromCSV() async {
    List<String> customerHeaders = [
      "id",
      "name",
      "email",
      "phoneNumber",
      "address"
    ];

    try {
      List<CustomerModel> customers =
          await CSVModule.uploadFromCSV<CustomerModel>(
        customerHeaders,
        (rowMap) => CustomerModel.fromMap(rowMap),
      );
      print("Customers uploaded: ${customers.length}");
    } catch (e) {
      print("Error uploading customers: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
                onPressed: () {
                  uploadTransactionsFromCSV();
                },
                label: Text("Upload Accounts From CSV")),
            TextButton.icon(
                onPressed: () {
                  uploadProductsFromCSV();
                },
                label: Text("Upload Products From CSV")),
            TextButton.icon(
                onPressed: () {
                  uploadCustomersFromCSV();
                },
                label: Text("Upload Customers From CSV")),
            TextButton.icon(
                onPressed: () {
                  uploadSuppliersFromCSV();
                },
                label: Text("Upload Suppliers From CSV")),
          ],
        ),
      ),
    );
  }
}
