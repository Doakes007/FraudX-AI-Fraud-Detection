import 'package:flutter/material.dart';

// 👤 User Screens
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/home_tab.dart';
import 'screens/send_money_tab.dart';
import 'screens/history_tab.dart';
import 'screens/fraud_tab.dart' as fraud;

// 🛠 Admin Screens
import 'screens/admin_dashboard.dart';
import 'screens/admin_users_screen.dart';
import 'screens/admin_stats_screen.dart';
import 'screens/all_transactions_screen.dart';
import 'screens/fraud_transactions_screen.dart';

// ⚙️ Settings Screen
import 'screens/settings_screen.dart';

void main() {
  runApp(const FraudXApp());
}

class FraudXApp extends StatelessWidget {
  const FraudXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FraudX',
      theme: ThemeData(primarySwatch: Colors.indigo),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Start from login

      routes: {
        // 👤 User Routes
        '/': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/home': (context) => const HomeTab(),
        '/send': (context) => const SendMoneyTab(),
        '/history': (context) => const HistoryTab(),
        '/fraud': (context) => const fraud.FraudTab(),

        // 🛠 Admin Routes
        '/admin_dashboard': (context) => const AdminDashboardScreen(),
        '/admin_users': (context) => const AdminUsersScreen(),
        '/admin_stats': (context) => const AdminStatsScreen(),
        '/all_transactions': (context) => const AllTransactionsScreen(),
        '/fraud_transactions': (context) => const FraudTransactionsScreen(),

        // ⚙️ Settings Route
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

