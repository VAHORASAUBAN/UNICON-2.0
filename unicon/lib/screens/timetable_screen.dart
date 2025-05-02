import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../services/AuthService.dart';
import '../services/Config.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  late String selectedDay;
  late String displayedDate;
  late Map<String, List<Map<String, String>>> weeklySchedule;

  final String courseName = "IMSCIT";

  bool isLoading = false; // To handle loading state

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String today = DateFormat('EEEE').format(now);
    selectedDay = days.contains(today) ? today : "Monday";
    displayedDate = _getDateForSelectedDay(selectedDay);
    weeklySchedule = {};
    _fetchTimetableData();
  }

  // Method to fetch timetable data from the API
  Future<void> _fetchTimetableData() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });
    final studentId = AuthService.studentId;
    try {
      final response = await http.get(Uri.parse('${Config.weeklyTimetable}?student_id=$studentId'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Log the raw data and decoded response for debugging
        print("Response Body: ${response.body}");
        print("Decoded Data: $data");

        if (data.containsKey('week_sessions')) {
          final weekSessions = data['week_sessions'];

          if (weekSessions is Map) {
            // Handle when 'week_sessions' is a Map
            setState(() {
              weeklySchedule = {}; // Reset the schedule
              weekSessions.forEach((day, sessions) {
                if (sessions is List) {
                  weeklySchedule[day] = [];
                  for (var session in sessions) {
                    print("Session Data: $session"); // Log each session data
                    weeklySchedule[day]?.add({
                      'subject': session['subject'] ?? 'No Subject',
                      'time': session['time'] ?? 'No Time',
                      'division': session['division'] ?? 'N/A',
                    });
                  }
                }
              });
            });
          } else if (weekSessions is List) {
            // Handle when 'week_sessions' is a List
            setState(() {
              weeklySchedule = {}; // Reset the schedule
              for (var session in weekSessions) {
                final day = session['day'];
                if (day != null) {
                  if (!weeklySchedule.containsKey(day)) {
                    weeklySchedule[day] = [];
                  }
                  print("Session Data: $session"); // Log each session data
                  weeklySchedule[day]?.add({
                    'subject': session['subject'] ?? 'No Subject',
                    'time': session['time'] ?? 'No Time',
                    'division': session['division'] ?? 'N/A',
                  });
                }
              }
            });
          } else {
            print("Unexpected structure for week_sessions: $weekSessions");
          }
        } else {
          print("No week_sessions found in the response");
        }
      } else {
        print("Failed to load timetable data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching timetable: $e"); // Handle API call error
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  String _getDateForSelectedDay(String dayName) {
    final DateTime now = DateTime.now();
    final int todayWeekday = now.weekday;
    final int selectedWeekday = days.indexOf(dayName) + 1;
    int daysDifference = selectedWeekday - todayWeekday;
    if (daysDifference < 0) daysDifference += 7;
    final DateTime selectedDate = now.add(Duration(days: daysDifference));
    return DateFormat('yMMMMd').format(selectedDate);
  }

  String getEndTime(String startTime) {
    try {
      final DateFormat formatter = DateFormat.jm();
      final DateTime startDateTime = formatter.parse(startTime);
      final DateTime endDateTime = startDateTime.add(Duration(hours: 1));
      return formatter.format(endDateTime);
    } catch (e) {
      return startTime; // Fallback if time parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Student Timetable",
          style: TextStyle(
            fontSize: 24,
            fontFamily: "Arial",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF004AAD),
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              "Date for $selectedDay: $displayedDate",
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: DropdownButtonFormField<String>(
              value: selectedDay,
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                labelText: "Select Day",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedDay = newValue!;
                  displayedDate = _getDateForSelectedDay(selectedDay);
                });
              },
              items: days.map((day) {
                return DropdownMenuItem(
                  value: day,
                  child: Text(
                    day,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: weeklySchedule[selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                var entry = weeklySchedule[selectedDay]![index];
                String subject = entry["subject"]!;
                String startTime = entry["time"]!;
                String endTime = getEndTime(startTime);
                String division = entry["division"]!;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            subject,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 18, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "$startTime - $endTime",
                                style: const TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.group, size: 20, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Division: $division",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.school, size: 20, color: Colors.grey),
                          const SizedBox(width: 6),
                          Text(
                            "Course: $courseName",
                            style: const TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
