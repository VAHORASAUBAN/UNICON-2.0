import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:unicon/services/AuthService.dart';

import '../../../services/Config.dart';

class FacultyTimetableScreen extends StatefulWidget {
  @override
  _FacultyTimetableScreenState createState() => _FacultyTimetableScreenState();
}

class _FacultyTimetableScreenState extends State<FacultyTimetableScreen> {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  late String selectedDay;
  late String displayedDate;
  bool isLoading = true;
  Map<String, List<Map<String, String>>> weeklySchedule = {};

  // Temporary faculty ID for demo
  String facultyId = "1"; // Replace with actual faculty ID from login

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String today = DateFormat('EEEE').format(now);
    selectedDay = days.contains(today) ? today : "Monday";
    displayedDate = _getDateForSelectedDay(selectedDay);
    fetchWeeklyTimetable();
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

  Future<void> fetchWeeklyTimetable() async {
    try {
      final response = await http.get(
        Uri.parse('${Config.fweeklyTimetable}?faculty_id=${AuthService.facultyId}'),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Map<String, List<Map<String, String>>> schedule = {};

        data['week_sessions'].forEach((day, sessions) {
          List<Map<String, String>> daySessions = [];
          for (var session in sessions) {
            daySessions.add({
              'subject': session['timetable_subject_name']['subject_name'],
              'time': session['lecture_start_time'],
              'division': session['division'],
            });
          }
          schedule[day] = daySessions;
        });

        setState(() {
          weeklySchedule = schedule;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        print("Failed to fetch timetable. Status: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching timetable: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Faculty Timetable",
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
      body: Column(
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
                  child: Text(day),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : (weeklySchedule[selectedDay] == null || weeklySchedule[selectedDay]!.isEmpty)
                ? const Center(
              child: Text(
                "No session today",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
                : ListView.builder(
              itemCount: weeklySchedule[selectedDay]!.length,
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

  String getEndTime(String startTime) {
    try {
      final DateFormat formatter = DateFormat.jm();
      final DateTime startDateTime = formatter.parse(startTime);
      final DateTime endDateTime = startDateTime.add(const Duration(hours: 1));
      return formatter.format(endDateTime);
    } catch (e) {
      return startTime;
    }
  }
}
