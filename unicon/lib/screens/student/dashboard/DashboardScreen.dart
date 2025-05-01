import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:unicon/services/Config.dart';
import 'dart:convert';

import '../../../widgets/AttendancePieChart.dart';
import '../../../../widgets/navbar.dart';
import '../placement/PlacementScreen.dart';
import '../sidemenu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  bool isProfileLoading = true;
  bool isTimetableLoading = true;

  List<dynamic> timetable = [];
  String userName = "";
  String userEmail = "";

  Future<void> fetchUserProfile() async {
    try {
      final response = await http.post(
        Uri.parse(Config.studentProfile),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"student_id": 1}),
      );

      print("Profile Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['firstname'] ?? 'Unknown';
          userEmail = data['email'] ?? 'Unknown';
          isProfileLoading = false;
        });
      } else {
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() => isProfileLoading = false);
    }
  }

  Future<void> fetchTimetable() async {
    try {
      final studentId = 1;
      final response = await http.get(Uri.parse('${Config.todayTimetable}?student_id=$studentId'));

      print("Timetable Response: ${response.statusCode} ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          timetable = jsonData['today_subjects'] ?? [];
          isTimetableLoading = false;
        });
      } else {
        print("Failed to load timetable: ${response.body}");
        setState(() => isTimetableLoading = false);
      }
    } catch (e) {
      print("Error fetching timetable: $e");
      setState(() => isTimetableLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTimetable();
    fetchUserProfile();
  }

  void _onTabSelected(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlacementScreen()),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _onScannerTap() {
    print('Scanner tapped');
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = isProfileLoading || isTimetableLoading;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF0A3B87),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SideMenu(
        userName: userName,
        userEmail: userEmail,
        onMenuTap: (route) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardContent(),
          PlacementScreen(),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        onScannerTap: _onScannerTap,
      ),
    );
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AttendancePieChart(),
          const SizedBox(height: 24),
          const Text(
            "Today's Classes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          timetable.isEmpty
              ? const Center(
            child: Text(
              "No Classes Today",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          )
              : _buildTimeline(),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: List.generate(timetable.length, (index) {
        final item = timetable[index];
        return _buildTimelineItem(
          item["timetable_subject_name"]["subject_name"] ?? "N/A",
          "${item["lecture_start_time"]} - ${item["lecture_end_time"]}",
          "Batch ${item["batch"]["batch_name"] ?? 'N/A'}",
          index == timetable.length - 1,
        );
      }),
    );
  }

  Widget _buildTimelineItem(String subject, String time, String batch, bool isLast) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 15,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade300,
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: Colors.blue.shade800,
                ),
            ],
          ),
          const SizedBox(width: 7),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A3B87), Color(0xFF004AAD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade300.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: _getSubjectIcon(subject),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subject,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          batch,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSubjectIcon(String subject) {
    if (subject.toLowerCase().contains("java")) {
      return const Icon(Icons.code, color: Colors.blue);
    } else if (subject.toLowerCase().contains("blockchain")) {
      return const Icon(Icons.security, color: Colors.green);
    } else if (subject.toLowerCase().contains("cns")) {
      return const Icon(Icons.computer, color: Colors.orange);
    } else {
      return const Icon(Icons.book, color: Colors.black);
    }
  }
}
