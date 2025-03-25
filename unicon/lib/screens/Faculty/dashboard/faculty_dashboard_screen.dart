import 'package:flutter/material.dart';
import '../../../styles/colors.dart';
import '../../../styles/fonts.dart';
import '../../../widgets/AttendancePieChart.dart';


import '../../../../widgets/faculty_navbar.dart';
import '../faculty_sidemenu.dart';

class FacultyDashboardScreen extends StatefulWidget {
  final String userName;

  const FacultyDashboardScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _FacultyDashboardScreenState createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onScannerTap() {
    print("Scanner button tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Arial",
            fontWeight: FontWeight.bold,
            color: Colors.white, // Remove AppColors.white for const support
          ),
        ),
        backgroundColor: AppColors.primaryBlue, // Use color from colors.dart
      ),
      drawer: faculty_sidemenu(
        onMenuTap: (route) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        userName: widget.userName,
        userEmail: "johndoe@example.com",
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardContent(),
          Center(
            child: Text(
              "Updates Content",
              style: AppFonts.comment.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FacultyNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        onScannerTap: _onScannerTap,
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AttendancePieChart(),
        ],
      ),
    );
  }
}
