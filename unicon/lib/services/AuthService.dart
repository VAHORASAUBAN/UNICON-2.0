/*
class AuthService {
  static const String mockUsername = "admin";
  static const String mockPassword = "1234";

  static Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // Mock validation
    if (username == mockUsername && password == mockPassword) {
      return true;
    }
    return false;
  }
}
*/
/*import 'dart:async';

class AuthService {
  static Future<bool> login(String username, String password) async {
    // Simulate a delay to mimic backend behavior
    await Future.delayed(const Duration(seconds: 1));

    // Hardcoded validation
    if (username == 'humed' && password == 'humed') {
      return true; // Successful login
    } else {
      return false; // Invalid credentials
    }
  }
}*/
class AuthService {
  static Future<bool> login(String username, String password, String userType) async {
    print("AuthService: Username -> $username, Password -> $password, UserType -> $userType"); // Debug
    await Future.delayed(const Duration(seconds: 1));

    // Check credentials based on userType (Student or Faculty)
    if (userType == 'Student') {
      if (username == 'humed' && password == 'humed') {
        print("AuthService: Student login successful");
        return true;
      }
    } else if (userType == 'Faculty') {
      if (username == 'faculty' && password == 'faculty') {
        print("AuthService: Faculty login successful");
        return true;
      }
    }

    print("AuthService: Invalid credentials");
    return false;
  }
}


