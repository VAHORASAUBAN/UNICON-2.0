import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicon/screens/Faculty/allstudents.dart';
import 'package:unicon/screens/Faculty/dashboard/Otp/otp_generator_screen.dart';
import 'package:unicon/screens/LoginScreen.dart';
import 'package:unicon/screens/LoginDetailsScreen.dart';
import 'package:unicon/screens/student/AttendanceReport.dart';
import 'package:unicon/screens/student/ProfileScreen.dart';
import 'package:unicon/screens/student/scanner/scanner_screen.dart';
import 'package:unicon/screens/timetable_screen.dart';
import 'screens/Faculty/TimeTable/time_table.dart';
import 'screens/student/Subject/subject.dart';
import 'screens/student/dashboard/DashboardScreen.dart';
import 'screens/student/placement/PlacementScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final String? userType = prefs.getString('userType');

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    userType: userType,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userType;

  const MyApp({super.key, required this.isLoggedIn, this.userType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UNICON',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: isLoggedIn ? '/dashboard' : '/',
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/': (context) => LoginScreen(),
        '/loginDetails': (context) => LoginDetailsScreen(userType: userType ?? ''),
        '/timetable': (context) => TimetableScreen(),
        '/scanner': (context) => ScannerScreen(),
        '/facultyTimetable': (context) => FacultyTimetableScreen(),
        '/allstudent': (context) => StudentListScreen(),
        '/subject': (context) => SubjectPage(),
        '/placements': (context) => PlacementScreen(),
        '/attendancereport': (context) => AttendanceReport(),
        '/otpGenerator': (context) => const OTPGeneratorScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
