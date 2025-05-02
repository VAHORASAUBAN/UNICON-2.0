
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static int? facultyId;
  static int? studentId;

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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();

      if (userType == 'Faculty') {
        facultyId = int.tryParse(data['faculty_id'].toString());
        await prefs.setString('userId', facultyId.toString());
      } else {
        studentId = int.tryParse(data['student_id'].toString());
        await prefs.setString('userId', studentId.toString());
      }

      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userType', userType);

      return true;
    }

    return false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}
