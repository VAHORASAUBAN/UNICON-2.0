import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "http://192.168.72.145:8000/student/";


  static Future<bool> login(String enrollment, String password, String userType) async {
    final response = await http.post(
      Uri.parse("${baseUrl}login/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"enrollment": enrollment, "password": password}),
    );

    if (response.statusCode == 200) {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  }
}
