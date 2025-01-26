import 'package:flutter/material.dart';
import 'package:unicon/shared/widgets/navbar.dart';

import 'features/screens/LoginDetailsScreen.dart';
import 'features/screens/LoginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug banner
      title: 'UNICON',
      theme: ThemeData(
        primarySwatch: Colors.indigo, // Set a theme color
        fontFamily: 'Roboto', // Set default font
      ),
      initialRoute: '/', // Define the initial route
      routes: {
        '/': (context) => LoginScreen(), // Start with LoginScreen
        '/loginDetails': (context) => LoginDetailsScreen(userType: ''), // LoginDetailsScreen with a placeholder
        '/dashboard': (context) => NavBar(), // NavBar for navigating Dashboard, QR Scanner, Notifications
      },
    );
  }
}
