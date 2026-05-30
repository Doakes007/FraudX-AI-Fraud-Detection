import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    if (globalUserId != null) {
      final result = await ApiService.getHistory(globalUserId!);
      setState(() {
        transactions = result["transactions"] ?? [];
      });
    }
  }

  Color getDirectionColor(String direction) {
    if (direction == 'incoming') return Colors.green;
    if (direction == 'outgoing') return Colors.blue;
    return Colors.grey;
  }

  Color getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? const Center(child: Text("No transactions yet."))
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final txn = transactions[index];
              final direction = txn["direction"];
              final directionColor = getDirectionColor(direction);
              final riskLevel = txn["risk_level"] ?? "unknown";

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Icon(
                        txn["is_fraud"] ? Icons.warning : Icons.check_circle,
                        color: txn["is_fraud"] ? Colors.red : directionColor,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹${(double.tryParse(
                                txn["amount"].toString(),
                              ) ?? 0.0).toStringAsFixed(2)}",
                              style: TextStyle(
                                color: directionColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${direction.toUpperCase()} | Type: ${txn["type"]}",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Chip(
                            label: Text(
                              riskLevel.toUpperCase(),
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            backgroundColor: getRiskColor(riskLevel),
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            txn["timestamp"] ?? "",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

