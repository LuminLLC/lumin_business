class Product {
   String? id;
  String name;
  String category;
  int quantity;
  double unitPrice;
  bool isPerishable;
  DateTime? expiryDate;
  Map<DateTime, int> dailySales = {};

  Product(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category,
      this.isPerishable = false,
      this.expiryDate,
      required this.unitPrice});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "category": category,
      "quantity": quantity,
      "unitPrice": unitPrice
    };
  }


}
