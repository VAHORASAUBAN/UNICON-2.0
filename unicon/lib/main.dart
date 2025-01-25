import 'package:flutter/material.dart';
import 'package:unicon/screens/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'Attendance Management App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange, // Set a theme color
        fontFamily: 'Roboto', // Set default font
      ),
      home: LoginScreen(), // Set LoginScreen as the home screen
    );
  }
}
