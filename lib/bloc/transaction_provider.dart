// transaction_provider.dart
import 'package:flutter/material.dart';
import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners(); // Notify all listening widgets to rebuild
  }
}
