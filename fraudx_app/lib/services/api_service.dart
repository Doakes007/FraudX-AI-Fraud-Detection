import 'dart:convert';
import 'package:http/http.dart' as http;
import 'device_helper.dart'; // ✅ Device + Location helpers
import 'ip_config.dart'; // ✅ For dynamic IP

String? globalToken;
int? globalUserId;
bool isAdmin = false;

class ApiService {
  // ✅ Dynamic base URL
  static Future<String> getBaseUrl() async {
    final ip = await IPConfig.getBackendIP() ?? '10.0.2.15'; // fallback
    return 'http://$ip:5000/api';
  }

  // 🔐 LOGIN
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final deviceId = await getDeviceId();
    final location = await getLocation();

    final url = Uri.parse('${await getBaseUrl()}/auth/login');
    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'device_id': deviceId,
        'location': location,
      }),
    );

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      globalToken = body['token'];
      globalUserId = body['user']['id'];
      isAdmin = body['user']['is_admin'] ?? false;
      return body;
    } else {
      return {"error": jsonDecode(res.body)["error"] ?? "Login failed"};
    }
  }

  static bool isAdminUser() => isAdmin;

  static void logout() {
    globalToken = null;
    globalUserId = null;
    isAdmin = false;
  }

  static Future<Map<String, dynamic>> getUser(int userId) async {
    final url = Uri.parse('${await getBaseUrl()}/user/$userId');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }

  static Future<double> getBalance(int userId) async {
    final url = Uri.parse('${await getBaseUrl()}/user/$userId/balance');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body['balance']?.toDouble() ?? 0.0;
    } else {
      return 0.0;
    }
  }

  static Future<Map<String, dynamic>> predictRisk(Map<String, dynamic> data) async {
    final deviceId = await getDeviceId();
    final location = await getLocation();

    final payload = {
      ...data,
      'device_id': deviceId,
      'location': location,
    };

    final url = Uri.parse('${await getBaseUrl()}/transaction/predict_risk');
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $globalToken',
      },
      body: jsonEncode(payload),
    );

    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> sendMoney(Map<String, dynamic> data) async {
    final deviceId = await getDeviceId();
    final location = await getLocation();

    final payload = {
      ...data,
      'device_id': deviceId,
      'location': location,
    };

    final url = Uri.parse('${await getBaseUrl()}/transaction/transfer');
    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $globalToken',
      },
      body: jsonEncode(payload),
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getHistory(int userId) async {
    final url = Uri.parse('${await getBaseUrl()}/transaction/history/$userId');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getFraud(int userId) async {
    final url = Uri.parse('${await getBaseUrl()}/transaction/fraud/$userId');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }

  static Future<Map<String, dynamic>> getAdminStats() async {
    final url = Uri.parse('${await getBaseUrl()}/admin/stats');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );
    return jsonDecode(res.body);
  }

  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final url = Uri.parse('${await getBaseUrl()}/admin/users');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } else {
      throw Exception("Failed to fetch users");
    }
  }

  static Future<List<Map<String, dynamic>>> getAllTransactions() async {
    final url = Uri.parse('${await getBaseUrl()}/admin/transactions/all');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } else {
      throw Exception("Failed to fetch all transactions");
    }
  }

  static Future<List<Map<String, dynamic>>> getFraudTransactions() async {
    final url = Uri.parse('${await getBaseUrl()}/admin/transactions/fraud');
    final res = await http.get(
      url,
      headers: {'Authorization': 'Bearer $globalToken'},
    );

    if (res.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } else {
      throw Exception("Failed to fetch fraud transactions");
    }
  }
}

