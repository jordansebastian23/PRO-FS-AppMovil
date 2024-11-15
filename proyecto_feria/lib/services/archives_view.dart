import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ArchivesView {
  static const String baseUrl = 'http://18.191.50.120';

  static Future<List<dynamic>> getUserAssignedFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/get_user_assigned_files/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('archivos')) {
        return responseBody['archivos'] as List<dynamic>;
      } else {
        throw Exception('Key "archivos" not found in response');
      }
    } else {
      throw Exception('Failed to get user assigned files: ${response.body}');
    }
  }
}