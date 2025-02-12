import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting dates

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
    "Sunday": [], // No classes on Sunday
  };

  // Get the current day of the week
  String getCurrentDay() {
    final dayOfWeek = DateFormat('EEEE').format(DateTime.now());
    return dayOfWeek;
  }

  @override
  Widget build(BuildContext context) {
    // Get today's classes
    String today = getCurrentDay();
    List<Map<String, String>> todaysClasses = weeklyClasses[today] ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: const Text(
          "Today's Timetable",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (todaysClasses.isEmpty)
              Center(child: Text("No Classes Today", style: TextStyle(fontSize: 18, color: Colors.grey)))
            else
              ...todaysClasses.map((classData) {
                return ClassCard(
                  subject: classData["subject"]!,
                  division: classData["division"]!,
                  time: classData["time"]!,
                );
              }).toList(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue.shade900,
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
              backgroundColor: Colors.blue.shade200,
              child: const Text("iM", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subject, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(division, style: const TextStyle(color: Colors.grey)),
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

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.home, size: 28), onPressed: () {}),
          const SizedBox(width: 40), // Space for floating button
          IconButton(icon: const Icon(Icons.notifications, size: 28), onPressed: () {}),
        ],
      ),
    );
  }
}
