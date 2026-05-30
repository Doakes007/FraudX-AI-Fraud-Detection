import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AllTransactionsScreen extends StatefulWidget {
  const AllTransactionsScreen({super.key});

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  List<dynamic> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() async {
    try {
      final result = await ApiService.getAllTransactions();
      setState(() {
        transactions = result;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading transactions: $e')),
      );
    }
  }

  Widget _buildTile(Map<String, dynamic> txn) {
    final timestamp = DateTime.parse(txn['timestamp']).toLocal().toString();

    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text("₹${txn['amount']} | ${txn['sender_name']} ➜ ${txn['receiver_name']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sender: ${txn['sender_email']} (${txn['sender_risk']})"),
            Text("Receiver: ${txn['receiver_email']} (${txn['receiver_risk']})"),
            Text("Time: $timestamp"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("All Transactions")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: transactions.map((txn) => _buildTile(txn)).toList(),
            ),
    );
  }
}

