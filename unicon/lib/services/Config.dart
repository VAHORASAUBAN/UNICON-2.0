class Config {
  static const String baseIp = "http://192.168.128.166:8000"; // <- Change IP only here

  // Auth Endpoints
  static const String studentLogin = "$baseIp/student/login/";
  static const String teacherLogin = "$baseIp/teacher/login/";

  // Profiles and other endpoints
  static const String studentProfile = "$baseIp/student/profile/";
  static const String teacherProfile = "$baseIp/teacher/profile/";

// Add more as needed, all use baseIp
}
