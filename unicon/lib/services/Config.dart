class Config {
  static const String baseIp = "http://192.168.1.47:8000"; // <- Change IP only here

  // Auth Endpoints
  static const String studentLogin = "$baseIp/student/login/";
  static const String teacherLogin = "$baseIp/teacher/login/";

  // Profiles and other endpoints
  static const String studentProfile = "$baseIp/student/profile/";
  static const String teacherProfile = "$baseIp/teacher/profile/";
  static const String allStudents = "$baseIp/teacher/students/";
  static const String allPlacements = "$baseIp/student/placements/";
  static const String todayTimetable = "$baseIp/student/today-sessions/";

  static const String fweeklyTimetable = "$baseIp/teacher/faculty_week_sessions/";
  static const String facultytodayTimetable = "$baseIp/teacher/faculty_today_sessions/";

  static const String weeklyTimetable = "$baseIp/student/student_week_sessions/";
  static const String markAttendance = "$baseIp/student/mark-attendance/";


}
