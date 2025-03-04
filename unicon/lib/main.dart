import 'package:flutter/material.dart';
import 'package:unicon/features/screens/LoginScreen.dart';
import 'package:unicon/features/screens/LoginDetailsScreen.dart';
import 'package:unicon/features/screens/student/scanner/scanner_screen.dart';
import 'package:unicon/features/screens/timetable_screen.dart';
import 'package:unicon/shared/styles/colors.dart';
import 'package:unicon/shared/styles/fonts.dart';
import 'features/screens/Faculty/TimeTable/time_table.dart';
import 'features/screens/student/Attendane_Report.dart';
import 'features/screens/student/Subject/subject.dart';
import 'features/screens/student/dashboard/DashboardScreen.dart';
import 'features/screens/student/placement/PlacementScreen.dart';

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
        '/subject': (context) => SubjectPage(),
        '/placements': (context) => PlacementScreen(),


        /*'/timetable': (context) =>  _FacultyTimetableScreenState(),*/



      },
    );
  }
}
