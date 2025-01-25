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
