import 'package:intl/intl.dart';

import '../models/transaction_model.dart';

String formatDate(DateTime date) {
  final DateFormat formatter =
      DateFormat('MMM dd, yyyy'); // e.g. November 26, 2023
  return formatter.format(date);
}

