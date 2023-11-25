import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomFABBottomAppBar extends StatelessWidget {
  const CustomFABBottomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 5,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
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
    );
  }
}

FloatingActionButton buildCustomFAB(BuildContext context) {
  return FloatingActionButton(
    shape: const CircleBorder(),
    backgroundColor: Colors.blue,
    onPressed: () => context.go('/form'),
    child: const Icon(Icons.add, color: Colors.white),
  );
}
