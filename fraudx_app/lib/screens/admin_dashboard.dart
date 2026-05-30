import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _logout(BuildContext context) {
    ApiService.logout();
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _buildAdminCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    Color iconColor = Colors.indigo,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: iconColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () => Navigator.pushNamed(context, route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FraudX Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              "Admin Tools",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          _buildAdminCard(
            context: context,
            icon: Icons.bar_chart,
            title: "View Admin Stats",
            route: '/admin_stats',
          ),
          _buildAdminCard(
            context: context,
            icon: Icons.people,
            title: "View All Users",
            route: '/admin_users',
          ),
          _buildAdminCard(
            context: context,
            icon: Icons.list_alt,
            title: "View All Transactions",
            route: '/all_transactions',
          ),
          _buildAdminCard(
            context: context,
            icon: Icons.warning_amber,
            iconColor: Colors.red,
            title: "View Fraud Transactions",
            route: '/fraud_transactions',
          ),
        ],
      ),
    );
  }
}

