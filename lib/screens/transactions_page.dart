import 'package:cashtrack/screens/skillup_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'home_screen.dart';

import '../models/sms_model.dart';
import 'transaction_detail_page.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  int _selectedIndex = 2;
  void _onBottomNavTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    }
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => SkillupPage()),
      );
    }
    // Add more navigation logic for other indices if needed
  }

  @override
  Widget build(BuildContext context) {
    final Color bgColor = const Color(0xFF1A1A1A);
    final Color textColor = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        backgroundColor: Colors.blue[500],
      ),
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
        valueListenable: Hive.box<SmsModel>('smsBox').listenable(),
        builder: (context, Box<SmsModel> box, _) {
          final messages = box.values
              .where((msg) => msg.type == 'transaction')
              .toList()
            ..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));

          if (messages.isEmpty) {
            return const Center(
              child: Text("No transactions available",
                  style: TextStyle(color: Colors.white70)),
            );
          }

          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final sms = messages[index];
              final isCredit = sms.body.toLowerCase().contains("credited with");
              final time =
              DateFormat('hh:mm a dd, MMM').format(sms.receivedAt);

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TransactionDetailPage(transaction: sms),
                    ),
                  );
                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.label, size: 18, color: textColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isCredit
                                  ? 'Received from ${sms.sender}'
                                  : 'Paid to ${sms.sender}',
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(sms.type ?? 'Unknown',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            Text(time,
                                style: const TextStyle(
                                    color: Colors.white38, fontSize: 10)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCredit ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          (isCredit ? '+' : '-') +
                              '₹${sms.amount?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF00CCE7),
        unselectedItemColor: const Color(0xFF949FA5),
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'SkillUp'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Splits'),
        ],
      ),
    );
  }
}
