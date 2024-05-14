import 'package:lumin_business/models/product.dart';

class LuminOrder {
  String? orderId;
  Map<Product, int> orderDetails;

  LuminOrder({
    this.orderId,
    required this.orderDetails,
  });
}
