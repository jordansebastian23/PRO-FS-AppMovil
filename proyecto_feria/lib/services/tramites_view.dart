import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TramitesView {
  static const String baseUrl = 'http://192.168.1.90:8000';

  static Future<List<dynamic>> checkTramitesUser() async {
    final url = Uri.parse('$baseUrl/check_tramites_user/');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token, // Include token if required
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('tramites')) {
        return responseBody['tramites'] as List<dynamic>;
      } else {
        throw Exception('Key "tramites" not found in response');
      }
    } else {
      throw Exception('Failed to get user tramites: ${response.body}');
    }
  }

  static Future<List<dynamic>> getTramitesConductor() async {
    final url = Uri.parse('$baseUrl/view_tramites_conductor/');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token, // Include token if required
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get conductor tramites: ${response.body}');
    }
  }

  

}