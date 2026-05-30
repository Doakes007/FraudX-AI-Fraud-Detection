import 'package:flutter/material.dart';
import 'package:fraudx_app/services/ip_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = TextEditingController();
  String _savedIP = '';

  @override
  void initState() {
    super.initState();
    _loadIP();
  }

  void _loadIP() async {
    final ip = await IPConfig.getBackendIP();
    setState(() {
      _savedIP = ip ?? '';
      _controller.text = _savedIP;
    });
  }

  void _saveIP() async {
    await IPConfig.setBackendIP(_controller.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backend IP saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Enter backend IP address:"),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(
                labelText: 'e.g. 192.168.1.5',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIP,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

