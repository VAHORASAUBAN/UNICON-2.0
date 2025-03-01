import 'package:flutter/material.dart';
import '../../../../shared/AttendancePieChart.dart';
import '../../../../shared/widgets/navbar.dart';
import '../placement/PlacementScreen.dart';
import '../sidemenu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Mock Timetable Data (Replace with API Data)
  final List<Map<String, String>> timetable = [
    {"subject": "CNS", "time": "07:30 AM", "batch": "iMscIT-Sem 7 (Div B)"},
    {"subject": "Blockchain", "time": "08:30 AM", "batch": "BCA-Sem 5 (Div A)"},
    {"subject": "Java", "time": "10:30 AM", "batch": "iMscIT-Sem 7 (Div B)"},
  ];

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
      drawer: SideMenu(
        onMenuTap: (route) {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        userName: "John Doe",
        userEmail: "johndoe@example.com",
      ),
      body: IndexedStack(
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

  // Dashboard Content with Timeline
  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Attendance Pie Chart
          AttendancePieChart(),
          const SizedBox(height: 24),

          // Today's Classes Section
          const Text(
            "Today's Classes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Timeline View
          if (timetable.isEmpty)
            const Center(
              child: Text(
                "No Classes Today",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          else
            _buildTimeline(),
        ],
      ),
    );
  }

  // Enhanced Timeline Widget
  Widget _buildTimeline() {
    return Column(
      children: List.generate(timetable.length, (index) {
        final item = timetable[index];
        return _buildTimelineItem(
          item["subject"] ?? "",
          item["time"] ?? "",
          item["batch"] ?? "",
          index == timetable.length - 1,
        );
      }),
    );
  }

  // Modern Timeline Item
  Widget _buildTimelineItem(String subject, String time, String batch, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Glowing Timeline Indicator
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
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
                height: 50,
                color: Colors.blue.shade800,
              ),
          ],
        ),
        const SizedBox(width: 12),

        // Class Details with Animated Card
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 8),
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
                // Subject Icon
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: _getSubjectIcon(subject),
                ),
                const SizedBox(width: 12),

                // Subject & Batch Details
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

                // Time Display
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
    );
  }

  // Dynamic Subject Icons
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
