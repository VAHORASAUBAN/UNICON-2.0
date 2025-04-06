import 'package:flutter/material.dart';
import '../../../styles/colors.dart';
import '../../../styles/fonts.dart';
import '../../../widgets/AttendancePieChart.dart';

import '../../../../widgets/faculty_navbar.dart';
import '../faculty_sidemenu.dart';

class FacultyDashboardScreen extends StatefulWidget {
  final String userName;

  const FacultyDashboardScreen({Key? key, required this.userName})
      : super(key: key);

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
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Menu icon color set to white
        ),
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
              "TimeTable",
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
/*import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unicon/features/screens/Faculty/faculty_sidemenu.dart';
import '../../../../shared/AttendancePieChart.dart';
import '../../../../shared/widgets/faculty_navbar.dart';
import 'package:unicon/shared/styles/colors.dart';
import 'package:unicon/shared/styles/fonts.dart';

class FacultyDashboardScreen extends StatefulWidget {
  final String userName;

  const FacultyDashboardScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _FacultyDashboardScreenState createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  int _currentIndex = 0;

  String getTodayDay() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  List<Map<String, String>> getTodayTimetable(String today) {
    Map<String, List<Map<String, String>>> timetableData = {
      'Monday': [
        {'subject': 'ADS', 'time': '09:00 - 10:00', 'division': 'A'},
        {'subject': 'Flutter', 'time': '10:00 - 11:00', 'division': 'A'},
        {'subject': 'MLP', 'time': '11:00 - 12:00', 'division': 'B'},
      ],
      'Tuesday': [
        {'subject': 'CNS', 'time': '09:00 - 10:00', 'division': 'A'},
        {'subject': 'ADS', 'time': '10:00 - 11:00', 'division': 'B'},
        {'subject': 'Flutter', 'time': '11:00 - 12:00', 'division': 'C'},
      ],
      'Wednesday': [
        {'subject': 'MLP', 'time': '09:00 - 10:00', 'division': 'C'},
        {'subject': 'ADS', 'time': '10:00 - 11:00', 'division': 'A'},
        {'subject': 'Flutter', 'time': '11:00 - 12:00', 'division': 'B'},
      ],
      // Add other days if needed
    };

    return timetableData[today] ?? [];
  }

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
    final today = getTodayDay();
    final todayTimetable = getTodayTimetable(today);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Arial",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
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
          _buildDashboardContent(today, todayTimetable),
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

  Widget _buildDashboardContent(String today, List<Map<String, String>> timetable) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AttendancePieChart(),

          const SizedBox(height: 20),

          Text(
            "Today's Timetable - $today",
            style: AppFonts.headline.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 10),

          timetable.isEmpty
              ? Text("No lectures today!", style: AppFonts.comment)
              : Column(
            children: timetable.map((entry) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Subject: ${entry['subject']}",
                            style: AppFonts.headline.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text("Time: ${entry['time']}", style: AppFonts.comment),
                        Text("Division: ${entry['division']}", style: AppFonts.comment),
                      ],
                    ),
                    const Icon(Icons.schedule, color: Colors.blueAccent),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}*/
