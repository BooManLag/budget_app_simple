import 'package:budget_app_simple/screens/transaction_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'bloc/transaction_provider.dart';
import 'screens/home_screen.dart';
import 'screens/transaction_form_screen.dart';

void main() {
  runApp(BudgetTrackerApp());
}

class BudgetTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GoRouter _router = GoRouter(
      routes: <GoRoute>[
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => HomeScreen(),
        ),
        GoRoute(
          path: '/transactions',
          builder: (BuildContext context, GoRouterState state) =>
              TransactionsScreen(),
        ),
        GoRoute(
          path: '/form',
          builder: (BuildContext context, GoRouterState state) =>
              TransactionFormScreen(),
        ),
        // Add more routes here
      ],
      // Optional: error handling, redirects, etc.
    );

    return ChangeNotifierProvider(
      // Initialize the provider here
      create: (context) => TransactionProvider(),
      child: MaterialApp.router(
        title: 'Budget Tracker',
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
