// import 'package:flutter/material.dart';
// import 'package:unicon/services/AuthService.dart';
// import '../../../services/Config.dart';
// import '../../../styles/colors.dart';
// import '../../../styles/fonts.dart';
// import '../../../widgets/AttendancePieChart.dart';
// import '../../../../widgets/faculty_navbar.dart';
// import '../faculty_sidemenu.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class FacultyDashboardScreen extends StatefulWidget {
//   final String userName;
//
//   const FacultyDashboardScreen({Key? key, required this.userName}) : super(key: key);
//
//   @override
//   _FacultyDashboardScreenState createState() => _FacultyDashboardScreenState();
// }
//
// class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
//   int _currentIndex = 0;
//   bool isLoading = true;
//   List<dynamic> timetable = [];
//
//   // Fetch timetable data (static example or real API fetch can be used here)
//
//   Future<void> fetchTimetable() async {
//     try {
//       final response = await http.get(
//         Uri.parse("${Config.facultyTodayTimetable}?faculty_id=${AuthService.facultyId.toString()}"),
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           timetable = data['today_sessions'].map((session) {
//             return {
//               "subject": session['timetable_subject_name']['subject_name'],
//               "time": "${session['lecture_start_time']} - ${session['lecture_end_time']}",
//               "batch": session['batch']['batch_name'],
//             };
//           }).toList();
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           timetable = [];
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       print("Error fetching faculty timetable: $e");
//       setState(() {
//         timetable = [];
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchTimetable(); // Fetch timetable data when the screen loads
//   }
//
//   void _onTabSelected(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }
//
//   void _onScannerTap() {
//     print("Scanner button tapped!");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           "Dashboard",
//           style: TextStyle(
//             fontSize: 24,
//             fontFamily: "Arial",
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//           ),
//         ),
//         backgroundColor: AppColors.primaryBlue,
//         iconTheme: const IconThemeData(
//           color: Colors.white, // Menu icon color set to white
//         ),
//       ),
//       drawer: faculty_sidemenu(
//         onMenuTap: (route) {
//           Navigator.pop(context);
//           Navigator.pushNamed(context, route);
//         },
//         userName: widget.userName,
//         userEmail: "",
//       ),
//       body: IndexedStack(
//         index: _currentIndex,
//         children: [
//           _buildDashboardContent(screenWidth, screenHeight),
//           Center(
//             child: Text(
//               "TimeTable",
//               style: AppFonts.comment.copyWith(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: FacultyNavBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabSelected,
//         onScannerTap: _onScannerTap,
//       ),
//     );
//   }
//
//   Widget _buildDashboardContent(double screenWidth, double screenHeight) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.04), // 4% padding on all sides
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AttendancePieChart(),
//             SizedBox(height: screenHeight * 0.03), // 3% height spacing
//
//             // Today's Classes Section
//             const Text(
//               "Today's Classes",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: screenHeight * 0.02), // 2% height spacing
//
//             // Timeline View: show loading, no classes, or the timeline
//             if (isLoading)
//               const Center(child: CircularProgressIndicator())
//             else if (timetable.isEmpty)
//               const Center(
//                 child: Text(
//                   "No Classes Today",
//                   style: TextStyle(fontSize: 16, color: Colors.black54),
//                 ),
//               )
//             else
//               _buildTimeline(screenWidth),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Enhanced Timeline Widget
//   Widget _buildTimeline(double screenWidth) {
//     return Column(
//       children: List.generate(timetable.length, (index) {
//         final item = timetable[index];
//         final subject = item["subject"] ?? "Unknown Subject";
//         final time = item["time"] ?? "Time not available";
//         final batch = item["batch"] ?? "Unknown Batch";
//
//         return _buildTimelineItem(
//           subject,
//           time,
//           batch,
//           index == timetable.length - 1,
//         );
//       }),
//     );
//   }
//   // Modern Timeline Item
//   Widget _buildTimelineItem(String subject, String time, String batch, bool isLast) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Timeline Column (Dot + Line)
//           Column(
//             children: [
//               // Circular Dot
//               Container(
//                 width: 15,
//                 height: 30,
//                 decoration: BoxDecoration(
//                   color: Colors.blue.shade800,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.blue.shade300,
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//               ),
//               if (!isLast)
//                 Container(
//                   width: 2,
//                   height: 40,
//                   color: Colors.blue.shade800,
//                 ),
//             ],
//           ),
//           const SizedBox(width: 7),
//
//           // Class Details Card
//           Expanded(
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 500),
//               curve: Curves.easeInOut,
//               margin: const EdgeInsets.symmetric(vertical: 4),
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF0A3B87), Color(0xFF004AAD)],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.blue.shade300.withOpacity(0.4),
//                     blurRadius: 8,
//                     offset: const Offset(2, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Colors.white,
//                     radius: 20,
//                     child: _getSubjectIcon(subject),
//                   ),
//                   const SizedBox(width: 12),
//
//                   // Subject & Batch Details
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           subject,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Text(
//                           batch,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Time Display
//                   Text(
//                     time,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   // Dynamic Subject Icons
//   Widget _getSubjectIcon(String subject) {
//     if (subject.toLowerCase().contains("java")) {
//       return const Icon(Icons.code, color: Colors.blue);
//     } else if (subject.toLowerCase().contains("blockchain")) {
//       return const Icon(Icons.security, color: Colors.green);
//     } else if (subject.toLowerCase().contains("cns")) {
//       return const Icon(Icons.computer, color: Colors.orange);
//     } else {
//       return const Icon(Icons.book, color: Colors.black);
//     }
//   }
// }
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
    final url = '${Config.facultyTodayTimetable}?faculty_id=${AuthService.facultyId}';
    try {
      final response = await http.get(Uri.parse(url), headers: {"Content-Type": "application/json"});
      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");  // Debugging the raw response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        print("Decoded data: $data");  // Debugging the decoded data

        setState(() {
          // Safely check if 'today_sessions' is a List
          timetable = List.from(data['today_sessions'] ?? []);  // Ensure it's a list
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
              const Center(child: Text("No Classes Today", style: TextStyle(fontSize: 16, color: Colors.black54)))
            else
              Column(
                children: List.generate(timetable.length, (i) {
                  final item = timetable[i];
                  // Print the item for debugging
                  print("Item $i: $item");

                  if (item is Map<String, dynamic>) {
                    final subject = item["timetable_subject_name"]["subject_name"] as String? ?? 'Unknown Subject';
                    final time = item["lecture_start_time"] as String? ?? 'Unknown Time';
                    final sem = item["semester"]?.toString() ?? 'N/A';
                    final div = item["division"] as String? ?? 'N/A';

                    return _buildTimelineItem(subject, time, sem, div, i == timetable.length - 1);
                  } else {
                    // Handle any invalid or unexpected data here
                    return SizedBox.shrink(); // Avoid rendering if item is invalid
                  }
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
