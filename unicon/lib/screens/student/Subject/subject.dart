/*
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SubjectPage(),
  ));
}

class SubjectPage extends StatefulWidget {
  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  int selectedSemester = 1;

  Map<int, List<String>> semesterSubjects = {
    1: [
      "NoSQL Databases",
      "Design and Analysis of Algorithms",
      "Cloud Computing and Virtualization",
      "Object Oriented Analysis and Design",
      "NoSQL Labs",
      "Object Oriented Programming"
    ],
    2: ["Subject A", "Subject B", "Subject C"],
    3: ["Subject X", "Subject Y", "Subject Z"],
    4: ["Advanced Topic 1", "Advanced Topic 2", "Advanced Topic 3"],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Syllabus Structure"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        backgroundColor: const Color(0xFF0A3B87),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Semester Tabs
          Container(
            color: const Color(0xFF0A3B87),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 1; i <= 4; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSemester = i;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "SEM $i",
                        style: TextStyle(
                          color: selectedSemester == i ? Colors.white : Colors.white70,
                          fontWeight: selectedSemester == i ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Subject List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: semesterSubjects[selectedSemester]?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.primaries[index % Colors.primaries.length],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      semesterSubjects[selectedSemester]![index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}*/
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SubjectPage(),
  ));
}

class SubjectPage extends StatefulWidget {
  @override
  _SubjectPageState createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  int selectedSemester = 1;

  Map<int, List<String>> semesterSubjects = {
    1: [
      "NoSQL Databases",
      "Design and Analysis of Algorithms",
      "Cloud Computing and Virtualization",
      "Object Oriented Analysis and Design",
      "NoSQL Labs",
      "Object Oriented Programming"
    ],
    2: ["Subject A", "Subject B", "Subject C"],
    3: ["Subject X", "Subject Y", "Subject Z"],
    4: ["Advanced Topic 1", "Advanced Topic 2", "Advanced Topic 3"],
  };

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double baseFontSize = screenWidth * 0.045; // Adjust font size dynamically

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Syllabus Structure"),
        titleTextStyle:
            TextStyle(color: Colors.white, fontSize: baseFontSize + 2),
        backgroundColor: const Color(0xFF0A3B87),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // Semester Tabs
          Container(
            color: const Color(0xFF0A3B87),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 1; i <= 4; i++)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSemester = i;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "SEM $i",
                        style: TextStyle(
                          color: selectedSemester == i
                              ? Colors.white
                              : Colors.white70,
                          fontWeight: selectedSemester == i
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: baseFontSize,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Subject List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: semesterSubjects[selectedSemester]?.length ?? 0,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.primaries[index % Colors.primaries.length],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      semesterSubjects[selectedSemester]![index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: baseFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
