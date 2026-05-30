import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';

/// Toggle this to true for testing with a spoofed device ID
const bool useFakeDeviceId = false;

/// ✅ Returns device ID (real or spoofed for testing)
Future<String> getDeviceId() async {
  if (useFakeDeviceId) {
    // 🔥 Hardcoded spoofed device ID for testing purposes
    return "Fake-Device-98765";
  }

  final deviceInfo = DeviceInfoPlugin();

  try {
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id ?? 'unknown_android';
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? 'unknown_ios';
    } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
      final baseInfo = await deviceInfo.deviceInfo;
      final name = baseInfo.data["name"] ?? "unknown_desktop";
      final version = baseInfo.data["version"] ?? "unknown_version";
      return "$name-$version";
    } else {
      return 'unsupported_platform';
    }
  } catch (e) {
    print("⚠️ Error fetching device ID: $e");
    return 'error_fetching_device';
  }
}

/// ✅ Returns current latitude and longitude as string
Future<String> getLocation() async {
  try {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return 'unknown';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return 'unknown';
      }
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return '${position.latitude},${position.longitude}';
  } catch (e) {
    print("⚠️ Error fetching location: $e");
    return 'unknown';
  }
}

