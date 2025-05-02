/*
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
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

class AuthService {
  static dynamic facultyId;

  static Future<bool> login(String id, String password, String userType) async {
    final String url =
    userType == 'Faculty' ? Config.teacherLogin.toString() : Config.studentLogin;

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userType == 'Faculty'
          ? {"faculty_id": id, "password": password}
          : {"enrollment": id, "password": password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (userType == 'Faculty') {
        // Parse the faculty_id as a dynamic value to support both int and String
        facultyId = data['faculty_id'];
        print("Logged in faculty ID: $facultyId");
      }
      return true;
    }
    return false;
  }
}
