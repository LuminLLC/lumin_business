
class ProductModel {
  String? id;
  dynamic image;
  String name;
  String category;
  int quantity;
  double unitPrice;
  bool isPerishable;
  DateTime? expiryDate;
  Map<DateTime, int> dailySales = {};

  ProductModel(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category,
      this.image,
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

  String toFormattedString() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('ID: ${id ?? "N/A"}');
    buffer.writeln('Name: $name');
    buffer.writeln('Category: $category');
    buffer.writeln('Quantity: $quantity');
    buffer.writeln('Unit Price: ${unitPrice.toStringAsFixed(2)}');
    buffer.writeln('Is Perishable: ${isPerishable ? "Yes" : "No"}');
    if (isPerishable && expiryDate != null) {
      buffer.writeln('Expiry Date: ${expiryDate!.toLocal()}');
    }
    return buffer.toString();
  }
}
