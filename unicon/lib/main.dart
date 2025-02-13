import 'package:flutter/material.dart';
import 'package:unicon/features/screens/LoginDetailsScreen.dart';
import 'package:unicon/shared/styles/colors.dart';
import 'package:unicon/shared/styles/fonts.dart';
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
        '/dasboard': (context) => const DashboardScreen(),
        '/loginDetails': (context) => LoginDetailsScreen(userType: ' '),

        /*'/timetable': (context) =>  _FacultyTimetableScreenState(),*/



      },
    );
  }
}
