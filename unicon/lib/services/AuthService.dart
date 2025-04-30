import 'dart:convert';
import 'package:http/http.dart' as http;
class AuthService {
  static const String studentUrl = "http://192.168.188.15:8000/student/login/";
  static const String teacherUrl = "http://192.168.188.15:8000/teacher/login/";

  static Future<bool> login(String id, String password, String userType) async {
    String url = userType == 'Faculty' ? teacherUrl : studentUrl;

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userType == 'Faculty'
          ? {"faculty_id": id, "password": password}
          : {"enrollment": id, "password": password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
