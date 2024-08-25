import 'package:lumin_business/modules/inventory/product_model.dart';

enum OrderStatus { Pending, Delivered, Cancelled }

class SupplyOrder {
  final String orderId;
  final String supplierId; // ID of the supplier
  final DateTime orderDate;
  final DateTime?
      deliveryDate; // Nullable, as delivery might not be completed yet
  final Map<String, List<double>> orderedProducts; // List of ordered products

  final OrderStatus status; // e.g., 'Pending', 'Delivered', 'Cancelled'
  final String? notes; // Optional field for additional notes

  SupplyOrder({
    required this.orderId,
    required this.supplierId,
    required this.orderDate,
    this.deliveryDate,
    required this.orderedProducts,
    required this.status,
    this.notes,
  });

  // Method to convert the model to a map for storage (e.g., Firebase)
  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "supplierId": supplierId,
      "orderDate": orderDate.toIso8601String(),
      "deliveryDate": deliveryDate?.toIso8601String(),
      "orderedProducts": orderedProducts,
      "status": status,
      "notes": notes,
    };
  }

  // Method to create a model from a map (e.g., when reading from a database)
  factory SupplyOrder.fromMap(Map<String, dynamic> map) {
    return SupplyOrder(
      orderId: map['orderId'],
      supplierId: map['supplierId'],
      orderDate: DateTime.parse(map['orderDate']),
      deliveryDate: map['deliveryDate'] != null
          ? DateTime.parse(map['deliveryDate'])
          : null,
      orderedProducts: {},
      
      status: map['status'],
      notes: map['notes'],
    );
  }

  double get totalCost {
    double result = 0;
    for (String key in orderedProducts.keys) {
      result += orderedProducts[key]![1];
    }
    return result;
  }
}
