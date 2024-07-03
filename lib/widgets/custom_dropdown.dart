import 'package:flutter/material.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';

import 'package:lumin_business/models/category.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:provider/provider.dart';

class CustomDropdownWidget extends StatefulWidget {
  

  CustomDropdownWidget({Key? key,  })
      : super(key: key);
  @override
  _CustomDropdownWidgetState createState() => _CustomDropdownWidgetState();
}

class _CustomDropdownWidgetState extends State<CustomDropdownWidget> {
  bool newCategorySelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<InventoryProvider, AppState>(
        builder: (context, InventoryProvider, appState, _) {
      return DropdownButtonFormField<String>(
        value: InventoryProvider.selectedCategory,
        onChanged: (newValue) {
          print(newValue);
          InventoryProvider.setSelectedCategory(newValue!);
          // Add your onChanged logic here
          // if (!hasChanges) {
          //   setState(() {
          //     hasChanges = true;
          //   });
          // }
        },
        decoration: InputDecoration(
          labelText: "Category",
          border: OutlineInputBorder(),
          hintText: "Enter Category",
        ),
        items: InventoryProvider.categories
            .map<DropdownMenuItem<String>>((ProductCategory value) {
          return DropdownMenuItem<String>(
            value: value.name,
            child: Text(value.name),
          );
        }).toList(),
      );
    });
  }
}
