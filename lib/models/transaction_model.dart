class Transaction {
  final String title;
  final String category;
  final double amount;
  final DateTime date;
  final String note;
  final bool isExpense; // true for expenses, false for income

  Transaction({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    required this.note,
    required this.isExpense,
  });
}
