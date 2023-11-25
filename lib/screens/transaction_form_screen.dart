import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../bloc/transaction_provider.dart';
import '../models/transaction_model.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({Key? key}) : super(key: key);

  @override
  _TransactionFormScreenState createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<bool> _selections = [true, false]; // For toggle buttons
  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final _categories = {
    'Income': ['Salary', 'Allowance'],
    'Expenses': ['Food', 'Entertainment'],
  };

  @override
  void initState() {
    super.initState();
    _selectedCategory = _categories['Income']!.first;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      Transaction newTransaction = Transaction(
        title: _selectedCategory ?? 'Undefined',
        category: _selections[0] ? 'Income' : 'Expense',
        amount: double.tryParse(_amountController.text) ?? 0,
        date: _selectedDate,
        isExpense: !_selections[0],
        note: _noteController.text,
      );

      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(newTransaction);

      GoRouter.of(context).go('/');
    }
  }

  void _handleCategoryChange(String? newValue) {
    setState(() {
      _selectedCategory = newValue!;
    });
  }

  Future<void> _onDatePick() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories =
        _selections[0] ? _categories['Income']! : _categories['Expenses']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Toggle buttons for Income/Expenses
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ToggleButtons(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text('Income'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: const Text('Expenses'),
                    ),
                  ],
                  isSelected: _selections,
                  onPressed: (int index) {
                    setState(() {
                      _selections[index] = !_selections[index];
                      _selections[1 - index] = !_selections[1 - index];
                      _selectedCategory =
                          _categories[_selections[0] ? 'Income' : 'Expenses']!
                              .first;
                    });
                  },
                  color: Colors.blue,
                  selectedColor: Colors.white,
                  fillColor: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Large Amount Input
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '₱',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              style: const TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // DropdownButtonFormField for category selection
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text('Select Category'),
              onChanged: _handleCategoryChange,
              items: categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // TextField for Note
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),

            // Date picker
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Colors.blue),
              title: Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              trailing: TextButton(
                child: const Text('Now'),
                onPressed: () {
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                },
              ),
              onTap: _onDatePick,
            ),
            const Divider(),

            // Save Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Save'),
              onPressed: _saveTransaction,
            ),
            const SizedBox(height: 10),

            // Cancel Button
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                GoRouter.of(context).go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
