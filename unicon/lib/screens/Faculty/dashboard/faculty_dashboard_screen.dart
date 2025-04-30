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
  bool isLoading = true;
  List<dynamic> timetable = [];

  // Fetch timetable data (static example or real API fetch can be used here)
  Future<void> fetchTimetable() async {
    // Replace with your actual timetable fetching code or static data.
    setState(() {
      timetable = [
        {"id": 1, "subject": "ADS", "time": "09:00 AM - 10:00 AM", "batch": "A"},
        {"id": 2, "subject": "Flutter", "time": "10:00 AM - 11:00 AM", "batch": "A"},
        {"id": 3, "subject": "MLP", "time": "11:00 AM - 12:00 PM", "batch": "B"},
      ];
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTimetable(); // Fetch timetable data when the screen loads
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
          const SizedBox(height: 24),

          // Today's Classes Section
          const Text(
            "Today's Classes",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          // Timeline View: show loading, no classes, or the timeline
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (timetable.isEmpty)
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
          item["subject"],
          item["time"],
          item["batch"],
          index == timetable.length - 1,
        );
      }),
    );
  }

  // Modern Timeline Item
  Widget _buildTimelineItem(String subject, String time, String batch, bool isLast) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Column (Dot + Line)
          Column(
            children: [
              // Circular Dot
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
                  width: 2, // Slim line for clean look
                  height: 40, // Adjust height for even spacing
                  color: Colors.blue.shade800,
                ),
            ],
          ),
          const SizedBox(width: 7 ), // Space between line & card

          // Class Details Card
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
      ),
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
