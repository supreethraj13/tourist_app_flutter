import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Point this to the backend API root (Android emulator loopback shown below).
  static const String baseUrl = 'http://10.0.2.2:5000/api';

  // Network defaults
  static const Duration _timeout = Duration(seconds: 20);

  // -----------------------
  // Auth token persistence
  // -----------------------
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // Common JSON headers with optional Bearer token
  static Map<String, String> _headers({String? token}) {
    return <String, String>{
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // Helper: Wrap http response into the app's expected shape
  static Map<String, dynamic> _wrap(http.Response response, {List<int>? ok}) {
    final okSet = ok ?? [];
    Map<String, dynamic> body;
    try {
      body = response.body.isNotEmpty ? jsonDecode(response.body) : {};
    } catch (_) {
      body = {'message': 'Invalid JSON from server', 'raw': response.body};
    }
    return {
      'success': okSet.contains(response.statusCode),
      'data': body,
      'statusCode': response.statusCode,
    };
  }

  // -----------------------
  // Auth endpoints
  // -----------------------

  // Register new tourist
  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> registrationData,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: _headers(),
            body: jsonEncode(registrationData),
          )
          .timeout(_timeout);
      // Backend may return 200 or 201 for success
      return _wrap(response, ok: const [200, 201]);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOTP(
    String email,
    String otp,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/verify-otp'),
            headers: _headers(),
            body: jsonEncode({'email': email, 'otp': otp}),
          )
          .timeout(_timeout);
      return _wrap(response, ok: const [200]);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Resend OTP
  static Future<Map<String, dynamic>> resendOTP(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/resend-otp'),
            headers: _headers(),
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeout);
      return _wrap(response, ok: const [200]);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // 🆕 Recover Tourist ID (email-based)
  static Future<Map<String, dynamic>> recoverTouristId(String email) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/recover-tourist-id'),
            headers: _headers(),
            body: jsonEncode({'email': email}),
          )
          .timeout(_timeout);
      return _wrap(response, ok: const [200]);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // Login with Tourist ID
  static Future<Map<String, dynamic>> login(String touristId) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: _headers(),
            body: jsonEncode({'touristId': touristId}),
          )
          .timeout(_timeout);
      return _wrap(response, ok: const [200]);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  // -----------------------
  // Location + SOS
  // -----------------------

  // Send location update
  static Future<bool> updateLocation(
    double lat,
    double lng,
    String address,
  ) async {
    final token = await getToken();
    if (token == null) return false;

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/location/track'),
            headers: _headers(token: token),
            body: jsonEncode({
              'latitude': lat,
              'longitude': lng,
              'address': address,
              'timestamp': DateTime.now().toIso8601String(),
            }),
          )
          .timeout(_timeout);
      return response.statusCode == 200;
    } catch (e) {
      // Optionally log e
      return false;
    }
  }

  // Trigger SOS emergency
  static Future<Map<String, dynamic>> triggerSOS(double lat, double lng) async {
    final token = await getToken();
    if (token == null) return {'success': false};

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/sos/alert'),
            headers: _headers(token: token),
            body: jsonEncode({
              'latitude': lat,
              'longitude': lng,
              'alertType': 'PANIC',
              'severity': 'CRITICAL',
              'description': 'Emergency SOS from mobile app',
            }),
          )
          .timeout(_timeout);
      return _wrap(response, ok: const [200]);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }
}
