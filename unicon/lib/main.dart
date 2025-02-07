import 'package:flutter/material.dart';
import 'package:unicon/features/screens/LoginScreen.dart';
import 'package:unicon/features/screens/LoginDetailsScreen.dart';
import 'package:unicon/features/screens/student/scanner/scanner_screen.dart';
import 'package:unicon/features/screens/timetable_screen.dart';
import 'features/screens/student/dashboard/DashboardScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

<<<<<<< HEAD
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

=======
>>>>>>> d02777fb5578d6d0195d1236c67bcf0ac45bf6d9
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
        '/scanner': (context) =>  ScannerScreen(),

      },
    );
  }
}
