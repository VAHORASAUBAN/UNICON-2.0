
import 'package:flutter/material.dart';
import 'features/screens/MenuBar.dart';
import 'features/screens/LoginScreen.dart';
import 'features/screens/LoginDetailsScreen.dart';
import 'package:unicon/features/screens/timetable_screen.dart' as timetable;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UNICON',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/loginscreen': (context) => LoginScreen(),
        '/loginDetails': (context) => LoginDetailsScreen(userType: ''),
        '/': (context) => DashboardScreen(),
        '/timetable': (context) => timetable.TimetableScreen(),
      },
    );
  }
}
