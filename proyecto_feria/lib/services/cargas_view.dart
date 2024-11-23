import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CargasView {
  static const String baseUrl = 'http://192.168.1.90:8000';

  static Future<List<dynamic>> getUserCargas() async {
    final url = Uri.parse('$baseUrl/cargas/check_cargas_pendientes/');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'X-Auth-Token': token, // Include token if required
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('cargas')) {
        print(responseBody['cargas'] as List<dynamic>);
        return responseBody['cargas'] as List<dynamic>;
      } else {
        throw Exception('Key "cargas" not found in response');
      }
    } else {
      throw Exception('Failed to get user cargas: ${response.body}');
    }
  }

}