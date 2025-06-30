import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/sms_model.dart';

class TransactionDetailPage extends StatelessWidget {
  final SmsModel transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.body.toLowerCase().contains('credited with');
    final Color bgColor = Colors.black;
    final Color textColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Detail'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isCredit ? 'Received from' : 'Paid to',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              transaction.sender,
              style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Amount', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(
              '₹${transaction.amount?.toStringAsFixed(2) ?? '0.00'}',
              style: TextStyle(
                color: isCredit ? Colors.greenAccent : Colors.redAccent,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text('Date & Time', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a dd MMM yyyy').format(transaction.receivedAt),
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('Original SMS', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 4),
            Text(
              transaction.body,
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
