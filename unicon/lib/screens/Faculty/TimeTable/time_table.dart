/*
import 'package:flutter/material.dart';

void main() {
  runApp(FacultyTimetableApp());
}

class FacultyTimetableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weekly Faculty Timetable',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FacultyTimetableScreen(),
    );
  }
}

class FacultyTimetableScreen extends StatelessWidget {
  final Map<String, List<Map<String, String>>> weeklyClasses = {
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
    "Sunday": [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87),
        title: const Text(
          "Weekly Timetable",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back button color set to white
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: weeklyClasses.keys.map((day) {
            List<Map<String, String>> classes = weeklyClasses[day]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0A3B87)),
                ),
                const SizedBox(height: 8),
                if (classes.isEmpty)
                  Center(child: Text("No Classes", style: TextStyle(fontSize: 16, color: Colors.grey)))
                else
                  ...classes.map((classData) {
                    return ClassCard(
                      subject: classData["subject"]!,
                      division: classData["division"]!,
                      time: classData["time"]!,
                    );
                  }).toList(),
                const SizedBox(height: 16),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String subject;
  final String division;
  final String time;

  const ClassCard({Key? key, required this.subject, required this.division, required this.time}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF0A3B87),
              child: const Text("iM", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  Text(division, style: const TextStyle(color: Colors.black)),
                ],
              ),
            ),
            Text(time, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FacultyTimetableScreen extends StatefulWidget {
  @override
  _FacultyTimetableScreenState createState() => _FacultyTimetableScreenState();
}

class _FacultyTimetableScreenState extends State<FacultyTimetableScreen> {
  final List<String> days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  late String selectedDay;
  late String displayedDate;

  final String courseName = "IMSCIT";

  final Map<String, List<Map<String, String>>> weeklySchedule = {
    "Monday": [
      {"subject": "ADS", "time": "9:00 AM", "division": "A"},
      {"subject": "CNS", "time": "10:00 AM", "division": "B"},
      {"subject": "MLP", "time": "11:00 AM", "division": "A"},
      {"subject": "HPC", "time": "12:00 PM", "division": "B"},
    ],
    "Tuesday": [
      {"subject": "Flutter", "time": "9:00 AM", "division": "B"},
      {"subject": "ADS Practical", "time": "10:00 AM", "division": "A"},
      {"subject": "CNS", "time": "11:00 AM", "division": "A"},
      {"subject": "MLP", "time": "12:00 PM", "division": "B"},
    ],
    "Wednesday": [
      {"subject": "HPC", "time": "9:00 AM", "division": "A"},
      {"subject": "Flutter", "time": "10:00 AM", "division": "A"},
      {"subject": "ADS", "time": "11:00 AM", "division": "B"},
      {"subject": "MLP", "time": "12:00 PM", "division": "B"},
    ],
    "Thursday": [
      {"subject": "ADS Practical", "time": "9:00 AM", "division": "B"},
      {"subject": "CNS", "time": "10:00 AM", "division": "A"},
      {"subject": "Flutter", "time": "11:00 AM", "division": "B"},
      {"subject": "HPC", "time": "12:00 PM", "division": "A"},
    ],
    "Friday": [
      {"subject": "ADS", "time": "9:00 AM", "division": "A"},
      {"subject": "MLP", "time": "10:00 AM", "division": "B"},
      {"subject": "CNS", "time": "11:00 AM", "division": "A"},
      {"subject": "Flutter", "time": "12:00 PM", "division": "B"},
    ],
    "Saturday": [
      {"subject": "HPC", "time": "9:00 AM", "division": "B"},
      {"subject": "ADS Practical", "time": "10:00 AM", "division": "A"},
      {"subject": "MLP", "time": "11:00 AM", "division": "B"},
    ],
  };

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    String today = DateFormat('EEEE').format(now);
    selectedDay = days.contains(today) ? today : "Monday";
    displayedDate = _getDateForSelectedDay(selectedDay);
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
      backgroundColor: Colors.white, // White background
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
              dropdownColor: Colors.white, // Dropdown background color white
              decoration: InputDecoration(
                labelText: "Select Day",
                filled: true,
                fillColor: Colors.white, // TextField box white
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
                    style: const TextStyle(color: Colors.black), // Text in dropdown
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

void main() {
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Roboto', primarySwatch: Colors.blue),
    debugShowCheckedModeBanner: false,
    home: FacultyTimetableScreen(),
  ));
}
