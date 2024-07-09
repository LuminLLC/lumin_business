import 'package:lumin_business/modules/inventory/product.dart';

class LuminOrder {
  String? orderId;
  Map<Product, int> orderDetails;

  LuminOrder({
    this.orderId,
    required this.orderDetails,
  });
}
