class LuminOrder {
  String orderId;
  Map<String, int> orderDetails;

  LuminOrder({
    required this.orderId,
    required this.orderDetails,
  });

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
