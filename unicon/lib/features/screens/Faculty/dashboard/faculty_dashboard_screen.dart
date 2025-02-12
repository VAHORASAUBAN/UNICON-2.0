import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:unicon/features/screens/Faculty/faculty_sidemenu.dart';
import '../../../../shared/widgets/faculty_navbar.dart';

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

  // Timetable data for each day
  final Map<String, List<Map<String, String>>> timetable = {
    "Monday": [
      {"subject": "CNS", "division": "iMscIT-Sem 7 (Div B)", "time": "07:00 AM - 08:00 AM"},
      {"subject": "ADS", "division": "iMscIT-Sem 7 (Div B)", "time": "08:00 AM - 09:00 AM"},
      {"subject": "Machine Learning", "division": "iMscIT-Sem 7 (Div A)", "time": "09:00 AM - 10:00 AM"},
      {"subject": "Blockchain", "division": "iMscIT-Sem 7 (Div B)", "time": "10:00 AM - 11:00 AM"},
    ],
    "Tuesday": [
      {"subject": "AI", "division": "iMscIT-Sem 7 (Div A)", "time": "07:00 AM - 08:00 AM"},
      {"subject": "Data Science", "division": "iMscIT-Sem 7 (Div B)", "time": "08:00 AM - 09:00 AM"},
      {"subject": "Cloud Computing", "division": "iMscIT-Sem 7 (Div A)", "time": "09:00 AM - 10:00 AM"},
    ],
    "Wednesday": [
      {"subject": "Big Data", "division": "iMscIT-Sem 7 (Div B)", "time": "07:00 AM - 08:00 AM"},
      {"subject": "Deep Learning", "division": "iMscIT-Sem 7 (Div A)", "time": "08:00 AM - 09:00 AM"},
      {"subject": "Cyber Security", "division": "iMscIT-Sem 7 (Div B)", "time": "09:00 AM - 10:00 AM"},
    ],
    "Thursday": [
      {"subject": "Internet of Things", "division": "iMscIT-Sem 7 (Div A)", "time": "07:00 AM - 08:00 AM"},
      {"subject": "Data Analytics", "division": "iMscIT-Sem 7 (Div B)", "time": "08:00 AM - 09:00 AM"},
      {"subject": "Software Engineering", "division": "iMscIT-Sem 7 (Div A)", "time": "09:00 AM - 10:00 AM"},
    ],
    "Friday": [
      {"subject": "DevOps", "division": "iMscIT-Sem 7 (Div A)", "time": "07:00 AM - 08:00 AM"},
      {"subject": "Ethical Hacking", "division": "iMscIT-Sem 7 (Div B)", "time": "08:00 AM - 09:00 AM"},
      {"subject": "Cloud Security", "division": "iMscIT-Sem 7 (Div A)", "time": "09:00 AM - 10:00 AM"},
    ],
    "Saturday": [
      {"subject": "Database Management", "division": "iMscIT-Sem 7 (Div B)", "time": "07:00 AM - 08:00 AM"},
      {"subject": "Full-Stack Development", "division": "iMscIT-Sem 7 (Div A)", "time": "08:00 AM - 09:00 AM"},
      {"subject": "AI Ethics", "division": "iMscIT-Sem 7 (Div B)", "time": "09:00 AM - 10:00 AM"},
    ],
    "Sunday": [], // No classes on Sunday
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
          _buildAttendanceChart(),
          SizedBox(height: 20),
          _buildTodayClasses(),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This Month Attendance Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(color: Colors.blue.shade800, value: 75, title: ""),
                      PieChartSectionData(color: Colors.blue.shade300, value: 25, title: ""),
                    ],
                  ),
                ),
              ),
              Text(
                '75%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBox("Present", "22", Colors.green),
              _buildStatBox("Absent", "03", Colors.orange),
              _buildStatBox("Total", "25", Colors.blue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 3),
            Text(
              value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayClasses() {
    String today = DateFormat('EEEE').format(DateTime.now()); // Get today's day

    List<Map<String, String>> todayClasses = timetable[today] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Today's Classes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        if (todayClasses.isEmpty)
          Text("No classes scheduled for today.", style: TextStyle(fontSize: 16, color: Colors.red))
        else
          ...todayClasses.map((cls) => _buildClassCard(cls)).toList(),
      ],
    );
  }

  Widget _buildClassCard(Map<String, String> cls) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      
    );
  }
}
