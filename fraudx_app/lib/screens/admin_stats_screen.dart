import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  _AdminStatsScreenState createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  void _fetchStats() async {
    setState(() => _isLoading = true);
    try {
      final result = await ApiService.getAdminStats();
      setState(() => _stats = result);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStat(String label, dynamic value, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: color, size: 30),
        title: Text(label, style: const TextStyle(fontSize: 18)),
        trailing: Text(
          "$value",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("📊 Admin Statistics")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _fetchStats(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 10),
                  _buildStat("Total Users", _stats["total_users"], Icons.people, Colors.blue),
                  _buildStat("Total Transactions", _stats["total_transactions"], Icons.swap_horiz, Colors.green),
                  _buildStat("Total Fraud Cases", _stats["total_frauds"], Icons.warning, Colors.red),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}

