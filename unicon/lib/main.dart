import 'package:flutter/material.dart';
import 'package:unicon/features/screens/LoginScreen.dart';
import 'package:unicon/features/screens/LoginDetailsScreen.dart';
import 'package:unicon/features/screens/student/scanner/scanner_screen.dart';
import 'package:unicon/features/screens/timetable_screen.dart';
import 'package:unicon/shared/styles/colors.dart';
import 'package:unicon/shared/styles/fonts.dart';
import 'features/screens/Faculty/Allstudent.dart';
import 'features/screens/Faculty/TimeTable/time_table.dart';
import 'features/screens/Faculty/dashboard/Otp/otp_generator_screen.dart';
import 'features/screens/student/Attendane_Report.dart';
import 'features/screens/student/Subject/subject.dart';
import 'features/screens/student/dashboard/DashboardScreen.dart';


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
        '/': (context) => LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/loginDetails': (context) => LoginDetailsScreen(userType: ' '),
        '/studentTimetable': (context) => TimetableScreen(),
        '/facultytimetable': (context) => FacultyTimetableScreen(),
        '/allstudent':(context) => StudentListScreen(),
        '/scanner': (context) => ScannerScreen(),
        '/subject': (context) => SubjectPage(),
        '/otpGenerator': (context) => const OTPGeneratorScreen(),
      },
    );
  }
}
