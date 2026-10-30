import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Lưu Access Token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  // Lấy Access Token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  // Xóa Token (Đăng xuất)
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  // Tạo Header tự động đính kèm Token
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Helper HTTP GET
  static Future<http.Response> get(String url) async {
    final headers = await getAuthHeaders();
    return await http.get(Uri.parse(url), headers: headers);
  }

  // Helper HTTP POST
  static Future<http.Response> post(String url, Map<String, dynamic> body) async {
    final headers = await getAuthHeaders();
    return await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // Helper HTTP PUT
  static Future<http.Response> put(String url, Map<String, dynamic> body) async {
    final headers = await getAuthHeaders();
    return await http.put(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );
  }

  // Helper HTTP DELETE
  static Future<http.Response> delete(String url) async {
    final headers = await getAuthHeaders();
    return await http.delete(
      Uri.parse(url),
      headers: headers,
    );
  }
}
