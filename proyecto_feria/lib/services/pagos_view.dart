import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PagosView {
  static const String baseUrl = 'http://192.168.1.90:8000';

  static Future<List<dynamic>> getUserPagos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/pagos/get_user_pagos/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': token,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('pagos')) {
        return responseBody['pagos'] as List<dynamic>;
      } else {
        throw Exception('Key "pagos" not found in response');
      }
    } else {
      throw Exception('Failed to get user pagos: ${response.body}');
    }
  }
}