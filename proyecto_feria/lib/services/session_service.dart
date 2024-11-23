import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('http://192.168.1.90:8000/users/login_user/');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Save the session cookie
      final responseData = jsonDecode(response.body);
      
      // Debug print to verify response fields
      print("Login response data: $responseData");

      // Store the token for authenticated requests
      final prefs = await SharedPreferences.getInstance();
      if (responseData['token'] != null) {
        prefs.setString('token', responseData['token']);
      } else {
        throw Exception('Token not found in response');
      }

      return responseData;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final url = Uri.parse('http://192.168.1.90:8000/users/get_user_details/');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }
  
  static Future<void> logoutCredentialsUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    // Call the API to logout and invalidate the token
    // Change the IP address to the server's IP
    final url = Uri.parse('http://192.168.1.90:8000/logout_user/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token,  // Pass the token to invalidate
      },
    );

    if (response.statusCode == 200) {
      // Remove the token and session data on successful logout
      await prefs.remove('token');
      await prefs.remove('loginType');
      print("User logged out successfully.");
    } else {
      print("Failed to logout: ${response.statusCode} ${response.body}");
    }
  }
}
