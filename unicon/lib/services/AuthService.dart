import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class AuthService {
  static Future<bool> login(String id, String password, String userType) async {
    final String url =
    userType == 'Faculty' ? Config.teacherLogin : Config.studentLogin;

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userType == 'Faculty'
          ? {"faculty_id": id, "password": password}
          : {"enrollment": id, "password": password}),
    );

    return response.statusCode == 200;
  }
}
