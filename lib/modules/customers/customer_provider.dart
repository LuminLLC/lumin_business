import 'package:flutter/material.dart';

class CustomerProvider with ChangeNotifier {
  List allCustomers =[];
  bool isCustomersFetched = true;
}