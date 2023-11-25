import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../bloc/transaction_provider.dart';
import '../models/transaction_model.dart';
import '../utils/utils.dart';

class TransactionsScreen extends StatefulWidget {
  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final incomeTransactions =
        transactionProvider.transactions.where((t) => !t.isExpense).toList();
    final expenseTransactions =
        transactionProvider.transactions.where((t) => t.isExpense).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expenses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTransactionList(incomeTransactions),
          _buildTransactionList(expenseTransactions),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blue,
        onPressed: () => context.go('/form'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 5,
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () => context.go('/'),
              ),
              const SizedBox(width: 48), // Placeholder for the FAB
              IconButton(
                icon: const Icon(Icons.account_balance_wallet),
                onPressed: () => context.go('/transactions'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionList(List<Transaction> transactions) {
    return ListView(
      children: transactions.map(buildTransactionTile).toList(),
    );
  }

  Widget buildTransactionTile(Transaction transaction) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.isExpense ? Colors.red : Colors.green,
          child: Icon(
            transaction.isExpense ? Icons.shopping_cart : Icons.attach_money,
            color: Colors.white,
          ),
        ),
        title: Text(transaction.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(formatDate(transaction.date)),
            if (transaction.note.isNotEmpty)
              Text(
                transaction.note,
                style: TextStyle(color: Colors.grey.shade600),
              ),
          ],
        ),
        trailing: Text(
          '${transaction.isExpense ? '-' : '+'}₱${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.isExpense ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
