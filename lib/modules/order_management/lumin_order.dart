import 'package:lumin_business/modules/inventory/product_model.dart';

class LuminOrder {
  String orderId;
  Map<ProductModel, int> orderDetails;

  LuminOrder({
    required this.orderId,
    required this.orderDetails,
  });

  double get orderTotal {
    double total = 0;
    for (ProductModel product in orderDetails.keys) {
      total += product.unitPrice * orderDetails[product]!;
    }
    return total;
  }

  Map<String, String> toMap() {
    // Convert orderDetails to a string representation
    String orderDetailsString = orderDetails.entries
        .map((entry) => "${entry.key}:${entry.value}")
        .join(", ");

    return {
      "orderID": this.orderId,
      "orderDetails": orderDetailsString,
    };
  }
}
