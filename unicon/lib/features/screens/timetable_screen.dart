/*
import 'package:flutter/material.dart';

class TimetableScreen extends StatelessWidget {
  // Sample data for the timetable
  final Map<String, List<String>> timetable = {
    "Monday": ["Math - 9:00 AM", "Science - 11:00 AM", "History - 2:00 PM"],
    "Tuesday": ["English - 9:00 AM", "Biology - 11:00 AM", "Art - 2:00 PM"],
    "Wednesday": ["Math - 9:00 AM", "Chemistry - 11:00 AM", "PE - 2:00 PM"],
    "Thursday": ["Physics - 9:00 AM", "Math - 11:00 AM", "History - 2:00 PM"],
    "Friday": ["Computer Science - 9:00 AM", "Music - 11:00 AM", "Geography - 2:00 PM"],
    "Saturday": ["Extra Class - 9:00 AM"],
    "Sunday": ["Holiday"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87),
        title: const Text(
          "Weekly Timetable",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: timetable.entries.map((entry) {
          String day = entry.key;
          List<String> classes = entry.value;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: classes.map((classItem) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(classItem),
                  );
                }).toList(),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
*/
// timetable_screen.dart
import 'package:flutter/material.dart';

// Data model to represent a subject with a time range
class Subject {
  final String name;
  final String timeRange;  // Time range such as "9:00 AM - 10:00 AM"

  Subject({required this.name, required this.timeRange});
}

class TimetableService {
  static final Map<String, List<Subject>> timetable = {
    "Monday": [
      Subject(name: "Math", timeRange: "9:00 AM - 10:00 AM"),
      Subject(name: "Science", timeRange: "11:00 AM - 12:00 PM"),
      Subject(name: "History", timeRange: "2:00 PM - 3:00 PM"),
    ],
    "Tuesday": [
      Subject(name: "English", timeRange: "9:00 AM - 10:00 AM"),
      Subject(name: "Biology", timeRange: "11:00 AM - 12:00 PM"),
      Subject(name: "Art", timeRange: "2:00 PM - 3:00 PM"),
    ],
    "Wednesday": [
      Subject(name: "Math", timeRange: "9:00 AM - 10:00 AM"),
      Subject(name: "Chemistry", timeRange: "11:00 AM - 12:00 PM"),
      Subject(name: "PE", timeRange: "2:00 PM - 3:00 PM"),
    ],
    "Thursday": [
      Subject(name: "Physics", timeRange: "9:00 AM - 10:00 AM"),
      Subject(name: "Math", timeRange: "11:00 AM - 12:00 PM"),
      Subject(name: "History", timeRange: "2:00 PM - 3:00 PM"),
    ],
    "Friday": [
      Subject(name: "Computer Science", timeRange: "9:00 AM - 10:00 AM"),
      Subject(name: "Music", timeRange: "11:00 AM - 12:00 PM"),
      Subject(name: "Geography", timeRange: "2:00 PM - 3:00 PM"),
    ],
    "Saturday": [
      Subject(name: "Extra Class", timeRange: "9:00 AM - 10:00 AM"),
    ],
    "Sunday": [Subject(name: "Holiday", timeRange: "")],
  };

  static List<Subject> getTodaysTimetable() {
    String today = DateTime.now().weekday == 7
        ? "Sunday"
        : ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][DateTime.now().weekday - 1];
    return timetable[today] ?? [Subject(name: "No classes today", timeRange: "")];
  }

  static List<Subject> getFullTimetable() {
    // Returns the full timetable for the week
    return timetable.entries.expand((entry) {
      return entry.value.map((subject) => subject);
    }).toList();
  }
}

class TimetableScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final timetableData = TimetableService.timetable;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87),
        title: const Text("Full Timetable",style: TextStyle(color: Colors.white),),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.black),
              children: [
                TableRow(
                  children: [
                    _buildTableCell('Time'),
                    _buildTableCell('Monday'),
                    _buildTableCell('Tuesday'),
                    _buildTableCell('Wednesday'),
                    _buildTableCell('Thursday'),
                    _buildTableCell('Friday'),
                    _buildTableCell('Saturday'),
                    _buildTableCell('Sunday'),
                  ],
                ),
                for (int i = 0; i < 4; i++) // Limit to 4 time slots (for example)
                  TableRow(
                    children: [
                      _buildTableCell(_getTimeSlot(i)),
                      _buildTableCell(_getSubjectForDay('Monday', i)),
                      _buildTableCell(_getSubjectForDay('Tuesday', i)),
                      _buildTableCell(_getSubjectForDay('Wednesday', i)),
                      _buildTableCell(_getSubjectForDay('Thursday', i)),
                      _buildTableCell(_getSubjectForDay('Friday', i)),
                      _buildTableCell(_getSubjectForDay('Saturday', i)),
                      _buildTableCell(_getSubjectForDay('Sunday', i)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  String _getTimeSlot(int index) {
    // Define the time slots based on index (e.g. "9:00 AM - 10:00 AM")
    final timeSlots = [
      "9:00 AM - 10:00 AM",
      "11:00 AM - 12:00 PM",
      "2:00 PM - 3:00 PM",
      "4:00 PM - 5:00 PM", // Add more if necessary
    ];
    return timeSlots[index];
  }

  String _getSubjectForDay(String day, int index) {
    final subjects = TimetableService.timetable[day];
    return subjects != null && index < subjects.length ? subjects[index].name : '';
  }
}
