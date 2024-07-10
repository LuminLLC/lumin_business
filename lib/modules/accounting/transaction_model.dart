enum TransactionType { income, expense }

class TransactionModel {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;

  TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
  });
}
