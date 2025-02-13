
class AuthService {
  static Future<bool> login(String username, String password, String userType) async {
    print("AuthService: Username -> $username, Password -> $password, UserType -> $userType"); // Debug
    await Future.delayed(const Duration(seconds: 1));

    // Check credentials based on userType (Student or Faculty)
    if (userType == 'Student') {
      if (username == '1' && password == '1') {
        print("AuthService: Student login successful");
        return true;
      }
    } else if (userType == 'Faculty') {
      if (username == '2' && password == '2') {
        print("AuthService: Faculty login successful");
        return true;
      }
    }

    print("AuthService: Invalid credentials");
    return false;
  }
}


