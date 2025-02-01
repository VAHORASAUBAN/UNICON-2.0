import 'package:flutter/material.dart';

class FacultyDashboardScreen extends StatelessWidget {
  final String userName;

  const FacultyDashboardScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Log out functionality goes here
              // For now, just pop the current screen to simulate logout
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to Dashboard, $userName!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
