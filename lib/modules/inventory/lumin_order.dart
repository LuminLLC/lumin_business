import 'package:lumin_business/modules/inventory/product_model.dart';

class LuminOrder {
  String? orderId;
  Map<ProductModel, int> orderDetails;

  LuminOrder({
    this.orderId,
    required this.orderDetails,
  });
}
