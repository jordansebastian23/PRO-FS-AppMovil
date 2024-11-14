import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsView {
  static const String baseUrl = 'http://10.32.104.37:8000';
  
  Future <List<dynamic>> getUserNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final url = Uri.parse('$baseUrl/user_notifications/');
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
      throw Exception('Failed to get user notifications: ${response.body}');
    }
  }
}