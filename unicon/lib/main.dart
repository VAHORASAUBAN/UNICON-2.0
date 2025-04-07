import 'package:flutter/material.dart';
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UNICON',
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/': (context) => LoginScreen(),
        '/loginDetails': (context) => LoginDetailsScreen(userType: ' '),
        '/timetable': (context) =>  TimetableScreen(),
        '/scanner': (context) =>  ScannerScreen(),
        '/timetable': (context) => FacultyTimetableScreen(),
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
