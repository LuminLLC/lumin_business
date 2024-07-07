import 'package:flutter/material.dart';
import 'package:lumin_business/common/app_colors.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/models/product.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/widgets/selected_product.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class ChartWidget extends StatefulWidget {
  /// Creates the home page.
  ChartWidget({Key? key}) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  List<Product> employees = [];
  late EmployeeDataSource employeeDataSource;

  void getEmployeeData(InventoryProvider i) async {
    await i.fetchProducts("xkqPlDPEqXWzglKBDV448W4Ghvu2");
    setState(() {
      employees = i.allProdcuts;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Consumer2<InventoryProvider, AppState>(
        builder: (context, inventoryProvider, appState, _) {
      final productController = Provider.of<InventoryProvider>(context);
      getEmployeeData(productController);
      employeeDataSource = EmployeeDataSource(employeeData: employees);
      return SfDataGrid(
        onCellTap: (DataGridCellTapDetails details) {
          if (details.rowColumnIndex.rowIndex > 0) {
            showDialog(
                // barrierDismissible: false,
                context: context,
                builder: (context) {
                  return SelectedProduct(
                    product: inventoryProvider.allProdcuts
                        .elementAt(details.rowColumnIndex.rowIndex - 1),
                    appState: appState,
                    inventoryProvider: inventoryProvider,
                  );
                });
          }
        },
        source: employeeDataSource,
        columnWidthMode: ColumnWidthMode.fill,
        columns: <GridColumn>[
          // chartHeader(s: "s", screenWidth: screenWidth),
          chartHeader(s: "Name", screenWidth: screenWidth),
          chartHeader(s: "Category", screenWidth: screenWidth),
          chartHeader(s: "Quantity", screenWidth: screenWidth),
          chartHeader(s: "Price", screenWidth: screenWidth),
        ],
      );
    });
  }

  GridColumn chartHeader({required String s, required double screenWidth}) {
    return GridColumn(
        columnName: s,
        label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              s,
              style: AppTextTheme()
                  .textTheme(screenWidth)
                  .bodyLarge!
                  .copyWith(color: AppColor.bgSideMenu),
            )));
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(this.id, this.name, this.designation, this.salary);

  /// Id of an employee.
  final int id;

  /// Name of an employee.
  final String name;

  /// Designation of an employee.
  final String designation;

  /// Salary of an employee.
  final int salary;
}

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class EmployeeDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EmployeeDataSource({required List<Product> employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              // DataGridCell<Widget>(
              //     columnName: "columnName",
              //     value: Container(
              //       color: Colors.amber,
              //       height: 10,
              //       width: 10,
              //     )),
              DataGridCell<String>(columnName: 'Name', value: e.name),
              DataGridCell<String>(columnName: 'Category', value: e.category),
              DataGridCell<int>(columnName: 'Quantity', value: e.quantity),
              DataGridCell<String>(
                  columnName: 'Price', value: "\u20B5${e.unitPrice}"),
            ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(
    DataGridRow row,
  ) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          e.value.toString(),
          style: TextStyle(fontSize: 12, color: AppColor.bgSideMenu),
        ),
      );
    }).toList());
  }
}
