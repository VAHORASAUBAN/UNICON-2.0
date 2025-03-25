import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyTimetableScreen extends StatefulWidget {
  @override
  _FacultyTimetableScreenState createState() => _FacultyTimetableScreenState();
}

class _FacultyTimetableScreenState extends State<FacultyTimetableScreen> {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  late String selectedDay;

  final Map<String, List<Map<String, String>>> weeklySchedule = {
    "Monday": [
      {"subject": "Math", "time": "9:00 AM"},
      {"subject": "Physics", "time": "11:00 AM"},
    ],
    "Tuesday": [
      {"subject": "Chemistry", "time": "10:00 AM"},
      {"subject": "Biology", "time": "1:00 PM"},
    ],
    "Wednesday": [
      {"subject": "English", "time": "9:00 AM"},
      {"subject": "Computer Science", "time": "2:00 PM"},
    ],
    "Thursday": [
      {"subject": "Math", "time": "10:00 AM"},
      {"subject": "Physics", "time": "3:00 PM"},
    ],
    "Friday": [
      {"subject": "History", "time": "11:00 AM"},
      {"subject": "Economics", "time": "4:00 PM"},
    ],
    "Saturday": [
      {"subject": "Physical Education", "time": "9:00 AM"},
    ],
  };

  @override
  void initState() {
    super.initState();
    String today = DateFormat('EEEE').format(DateTime.now());
    selectedDay = days.contains(today) ? today : "Monday";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Weekly Timetable")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: DropdownButtonFormField<String>(
              value: selectedDay,
              decoration: InputDecoration(
                labelText: "Select a Day",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (newValue) {
                setState(() {
                  selectedDay = newValue!;
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
            child: ListView.builder(
              itemCount: weeklySchedule[selectedDay]?.length ?? 0,
              itemBuilder: (context, index) {
                var entry = weeklySchedule[selectedDay]![index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry["subject"]!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade700),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Time: ${entry["time"]!}",
                        style: TextStyle(fontSize: 16, color: Colors.black87),
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

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.blue),
    home: FacultyTimetableScreen(),
  ));
}