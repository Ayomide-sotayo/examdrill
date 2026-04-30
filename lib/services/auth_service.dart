import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  final String baseUrl = 'https://examdash-test-api.kudibase.com';
  final _storage = const FlutterSecureStorage();
  
  String? _token;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;

  String? get token => _token;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthService() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    _token = await _storage.read(key: 'auth_token');
    if (_token != null) {
      await getProfile();
    }
    notifyListeners();
  }

  Future<bool> requestOTP(String email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/request-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      _isLoading = false;
      notifyListeners();
      return response.statusCode == 200;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyOTP(String email, String code) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        await _storage.write(key: 'auth_token', value: _token);
        await getProfile();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> enroll({
    required String displayName,
    required String accessCode,
    required String resourceId,
    String? enrollmentToken,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/enroll'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'display_name': displayName.trim(),
          'access_code': accessCode.trim(),
          'resource_id': resourceId,
          'enrollment_token': enrollmentToken ?? _token,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        await _storage.write(key: 'auth_token', value: _token);
        await getProfile();
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getProfile() async {
    if (_token == null) return;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        _userProfile = jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        // Only logout if we already have a profile (meaning a real session expired)
        // For new users, /auth/me will 401 until they call /auth/enroll
        if (_userProfile != null) {
          await logout();
        }
      }
    } catch (e) {
      // Error ignored
    }
    notifyListeners();
  }

  Future<List<dynamic>> getResources() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/resources'),
        headers: {
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      // Error ignored
    }
    return [];
  }

  Future<void> logout() async {
    _token = null;
    _userProfile = null;
    await _storage.delete(key: 'auth_token');
    notifyListeners();
  }
}
