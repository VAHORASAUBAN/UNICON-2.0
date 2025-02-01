import 'package:flutter/material.dart';
import 'package:unicon/features/screens/dashboard/DashboardScreen.dart';
import 'package:unicon/features/screens/LoginScreen.dart';
import 'package:unicon/features/screens/LoginDetailsScreen.dart';
import 'package:unicon/features/screens/timetable_screen.dart';

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
        '/': (context) => LoginScreen(),
        '/loginDetails': (context) => LoginDetailsScreen(userType: ' '),
        '/timetable': (context) =>  TimetableScreen(),
      },
    );
  }
}
