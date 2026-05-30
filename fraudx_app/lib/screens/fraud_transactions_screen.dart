import 'package:flutter/material.dart';
import '../services/api_service.dart';

class FraudTransactionsScreen extends StatefulWidget {
  const FraudTransactionsScreen({super.key});

  @override
  State<FraudTransactionsScreen> createState() => _FraudTransactionsScreenState();
}

class _FraudTransactionsScreenState extends State<FraudTransactionsScreen> {
  List<dynamic> frauds = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFraudTransactions();
  }

  void _loadFraudTransactions() async {
    try {
      final result = await ApiService.getFraudTransactions();
      setState(() {
        frauds = result;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading fraud transactions: $e')),
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
        trailing: const Icon(Icons.warning, color: Colors.red),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fraud Transactions")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: frauds.map((txn) => _buildTile(txn)).toList(),
            ),
    );
  }
}

