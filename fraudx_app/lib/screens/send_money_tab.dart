import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SendMoneyTab extends StatefulWidget {
  const SendMoneyTab({super.key});

  @override
  State<SendMoneyTab> createState() => _SendMoneyTabState();
}

class _SendMoneyTabState extends State<SendMoneyTab> {
  final TextEditingController _toIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String responseMessage = "";
  String _selectedType = "TRANSFER";
  bool _isLoading = false;

  final List<String> _transactionTypes = [
    "TRANSFER",
    "CASH_OUT",
    "PAYMENT",
    "DEBIT",
    "CASH_IN"
  ];

  Future<void> _predictAndConfirm() async {
    final toId = int.tryParse(_toIdController.text);
    final amount = double.tryParse(_amountController.text);

    if (toId == null || amount == null || globalUserId == null) {
      setState(() => responseMessage = "❌ Invalid input");
      return;
    }

    // Prevent self transfer
    if (toId == globalUserId) {
      setState(() {
        responseMessage =
            "Cannot send money to yourself";
      });
      return;
    }

    // Prevent negative amount
    if (amount <= 0) {
      setState(() {
        responseMessage =
            "Amount must be greater than 0";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      responseMessage = "";
    });

    final predictRes = await ApiService.predictRisk({
      "from_id": globalUserId!,
      "to_id": toId,
      "amount": amount,
      "type": _selectedType,
    });

    setState(() => _isLoading = false);

    if (predictRes.containsKey('fraud_chance_percent')) {
      final fraudPercent = predictRes['fraud_chance_percent'];
      final riskLevel = predictRes['risk_level'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Fraud Risk Analysis"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "🧠 Fraud Probability",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: fraudPercent / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    fraudPercent >= 70
                        ? Colors.red
                        : fraudPercent >= 40
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "$fraudPercent%",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Text(
                  "⚠️ Risk Level: $riskLevel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: riskLevel == "high"
                        ? Colors.red
                        : riskLevel == "medium"
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Do you want to proceed with this transaction?",
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performTransfer(toId, amount);
                },
                child: const Text("Proceed"),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        responseMessage =
            predictRes['error'] ??
                "❌ Failed to evaluate risk";
      });
    }
  }

  Future<void> _performTransfer(
      int toId,
      double amount,
      ) async {

    setState(() => _isLoading = true);

    final res = await ApiService.sendMoney({
      "from_id": globalUserId!,
      "to_id": toId,
      "amount": amount,
      "type": _selectedType,
    });

    setState(() {
      _isLoading = false;

      responseMessage = res.containsKey('is_fraud')
          ? (res['is_fraud']
          ? "⚠️ Transaction flagged as FRAUD!"
          : "✅ Transaction completed safely.")
          : (res['error'] ?? "❌ Transaction failed.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send Money",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: _toIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Recipient User ID",
              ),
            ),

            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount (₹)",
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: "Transaction Type",
              ),
              items: _transactionTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) =>
                  setState(() => _selectedType = value!),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:
              _isLoading ? null : _predictAndConfirm,
              child: _isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
              )
                  : const Text("Send"),
            ),

            const SizedBox(height: 10),

            Text(
              responseMessage,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}