class ProductModel {
  String? id;
  dynamic image;
  String name;
  String category;
  int quantity;
  double unitPrice;
  double unitCost;
  bool isPerishable;
  DateTime? expiryDate;
  Map<DateTime, int> dailySales = {};

  ProductModel({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    required this.unitCost,
    this.image,
    this.isPerishable = false,
    this.expiryDate,
    required this.unitPrice,
  });

  // toMap method
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "quantity": quantity,
      "unitPrice": unitPrice,
      'unitCost': unitCost,
      "isPerishable": isPerishable,
      "expiryDate": expiryDate?.toIso8601String(),
      // Convert dailySales map to a more serializable format (e.g., Map<String, int>)
      "dailySales": dailySales
          .map((key, value) => MapEntry(key.toIso8601String(), value)),
    };
  }

  // fromMap method
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      quantity: map['quantity'],
      unitPrice: map['unitPrice'],
      unitCost: map['unitCost'] ?? 0,
      isPerishable: map['isPerishable'] ?? false,
      expiryDate:
          map['expiryDate'] != null ? DateTime.parse(map['expiryDate']) : null,
      // Convert the dailySales map back from a serializable format
      // dailySales: Map<DateTime, int>.from(map['dailySales'].map((key, value) => MapEntry(DateTime.parse(key), value))),
    );
  }

  @override
  String toString() {
    return this.id! +
        this.name +
        this.quantity.toString() +
        this.category +
        this.unitPrice.toString();
  }
}
