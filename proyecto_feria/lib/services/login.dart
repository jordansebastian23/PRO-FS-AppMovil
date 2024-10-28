import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginService {
  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    // Cambiar ip a la del servidor cuando se suba
    final url = Uri.parse('http://192.168.1.88:8000/login_user/');

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
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }
}