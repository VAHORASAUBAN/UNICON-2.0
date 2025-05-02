

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../services/AuthService.dart';
import '../../../services/Config.dart';
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
  bool isLoading = true;
  List<dynamic> timetable = [];

  @override
  void initState() {
    super.initState();
    fetchTimetable();
  }

  Future<void> fetchTimetable() async {
    final url = '${Config.facultytodayTimetable}?faculty_id=${AuthService.facultyId}';
    try {
      final response = await http.get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        setState(() {
          timetable = data['today_sessions'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          timetable = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching timetable: $e");
      setState(() {
        timetable = [];
        isLoading = false;
      });
    }
  }

  void _onTabSelected(int index) => setState(() => _currentIndex = index);
  void _onScannerTap() => print("Scanner tapped!");

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Dashboard",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: faculty_sidemenu(
        userName: widget.userName,
        userEmail: "johndoe@example.com",
        onMenuTap: (route) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardContent(sw, sh),
          Center(child: Text("TimeTable",
              style: AppFonts.comment.copyWith(fontSize: 22, fontWeight: FontWeight.bold))),
        ],
      ),
      bottomNavigationBar: FacultyNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected,
        onScannerTap: _onScannerTap,
      ),
    );
  }

  Widget _buildDashboardContent(double sw, double sh) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(sw * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AttendancePieChart(),
            SizedBox(height: sh * 0.03),
            const Text("Today's Classes", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            SizedBox(height: sh * 0.02),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (timetable.isEmpty)
              const Center(child: Text("No Classes Today",
                  style: TextStyle(fontSize: 16, color: Colors.black54)))
            else
              Column(
                children: List.generate(timetable.length, (i) {
                  final item = timetable[i] as Map<String,dynamic>;
                  final subject = item["timetable_subject_name"]["subject_name"] as String;
                  final time = item["lecture_start_time"] as String;
                  final sem = item["semester"]?.toString() ?? 'N/A';
                  final div = item["division"] as String? ?? 'N/A';

                  return _buildTimelineItem(subject, time, sem, div, i == timetable.length - 1);
                }),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
      String subject,
      String time,
      String sem,
      String div,
      bool isLast,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dot & line
          Column(
            children: [
              Container(
                width: 15,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blue.shade800,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.blue.shade300, blurRadius: 8)],
                ),
              ),
              if (!isLast)
                Container(width: 2, height: 40, color: Colors.blue.shade800),
            ],
          ),
          const SizedBox(width: 7),

          // Details card
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0A3B87), Color(0xFF004AAD)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.blue.shade300.withOpacity(0.4), blurRadius: 8, offset: Offset(2,4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Subject & time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(subject, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 18, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(time, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Sem & Div
                  Row(
                    children: [
                      const Icon(Icons.school, size: 18, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text('Sem: $sem', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                      const SizedBox(width: 16),
                      const Icon(Icons.group, size: 18, color: Colors.white70),
                      const SizedBox(width: 6),
                      Text('Div: $div', style: const TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
