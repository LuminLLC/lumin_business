class OrderItem {
  String productID;
  int quantity;
  double price;

  OrderItem({
    required this.productID,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productID: map['productID'],
      quantity: map['quantity'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "productID": this.productID,
      "quantity": this.quantity,
      "price": this.price,
    };
  }

  double get itemTotal {
    return this.price * this.quantity;
  }
}

class LuminOrder {
  dynamic orderId;

  List<OrderItem> orderItems;
  String? status;
  String? pos;
  String? customer;

  LuminOrder({
    required this.orderId,
    required this.orderItems,
    this.status,
    this.customer,
    this.pos,
  });

  void setOrderStatus(String status) {
    this.status = status;
  }

  double get orderTotal {
    double total = 0;
    for (OrderItem item in orderItems) {
      total += item.itemTotal;
    }
    return total;
  }

  List<String> get productIDs {
    return orderItems.map((e) => e.productID).toList();
  }

  factory LuminOrder.fromMap(Map<String, dynamic> map) {
    return LuminOrder(
      orderId: map['orderID'],
      orderItems: [
        for (Map<String, dynamic> item in map['orderDetails'])
          OrderItem.fromMap(item),
      ],
      status: map['status'],
      pos: map['pos'],
      customer: map['customer'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "orderID": this.orderId,
      "pos": this.pos,
      "customer": this.customer,
      "orderDetails": [
        for (OrderItem item in this.orderItems) item.toMap(),
      ],
      "status": this.status,
    };
  }
}
