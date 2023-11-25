import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/transaction_provider.dart';
import '../widgets/custom_fab_bottom_app_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);

    // Calculate total income and expenses
    double totalIncome = 0.0;
    double totalExpenses = 0.0;
    for (var transaction in transactionProvider.transactions) {
      if (transaction.isExpense) {
        totalExpenses += transaction.amount;
      } else {
        totalIncome += transaction.amount;
      }
    }
    double balance = totalIncome - totalExpenses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          CircleAvatar(
            backgroundImage: NetworkImage('https://images.lifestyleasia.com/wp-content/uploads/sites/7/2023/04/17235632/Park-Seo-Joon-movies-and-dramas-Korean-2.jpg'),
            radius: 20.0,
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Balance section
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('₱${balance.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_downward, color: Colors.red),
                    Text('₱${totalExpenses.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white)),
                    SizedBox(width: 16),
                    Icon(Icons.arrow_upward, color: Colors.green),
                    Text('₱${totalIncome.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          // Transaction History
          Expanded(
            child: ListView.builder(
              itemCount: transactionProvider.transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactionProvider.transactions[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    title: Text(transaction.title),
                    subtitle: Text(
                        '₱${transaction.amount.toStringAsFixed(2)} - ${transaction.category}'),
                    trailing: Icon(
                        transaction.isExpense
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color:
                            transaction.isExpense ? Colors.red : Colors.green),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: buildCustomFAB(context), // Use the custom FAB here
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const CustomFABBottomAppBar(),
    );
  }
}
