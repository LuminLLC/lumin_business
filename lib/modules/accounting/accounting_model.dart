
enum TransactionType { income, expense }


class AccountingModel {
  final String id;
  final String description;
  final double amount;
  final String date;
  final TransactionType type;
  String? saleID;
  String? purchaseOrderID;

  AccountingModel(
      {required this.id,
      required this.description,
      required this.amount,
      required this.date,
      required this.type,
      this.saleID,
      this.purchaseOrderID})
      : assert(!(saleID != null && purchaseOrderID != null),
            'A transaction cannot have both saleID and purchaseOrderID at the same time');

  // Convert the TransactionModel to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date, // Store date as a string in ISO 8601 format
      'type': type.toString().split('.').last, // Store the enum as a string
    };
  }

  // Create a TransactionModel from a Map
  factory AccountingModel.fromMap(Map<String, dynamic> map) {
    return AccountingModel(
      id: map['id'],
      description: map['description'],
      amount: map['amount'],
      date: map['date'],
      type: TransactionType.values
          .firstWhere((e) => e.toString().split('.').last == map['type']),
    );
  }

  @override
  String toString() {
    return 'id: $id\ndescription: $description\namount: $amount\ndate: $date\ntype: ${type.toString().split('.').last}\n';
  }
}
