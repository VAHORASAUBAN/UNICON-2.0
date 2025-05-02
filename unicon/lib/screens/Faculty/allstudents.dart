import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/Config.dart';

// Student Model
class Student {
  final String name;
  final String course;
  final String sem;
  final String div;
  final String? imageUrl;

  Student({
    required this.name,
    required this.course,
    required this.sem,
    required this.div,
    this.imageUrl,
  });
}

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> allStudents = [];
  List<Student> filteredStudents = [];

  int currentPage = 0;
  final int studentsPerPage = 10;

  String selectedCourse = "All";
  String selectedSemester = "All";
  String selectedDivision = "All";

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      final response = await http.get(
        Uri.parse(Config.allStudents),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Student> fetchedStudents = data.map((studentData) {
          return Student(
            name: "${studentData['firstname'] ?? ''} ${studentData['lastname'] ?? ''}",
            course: studentData['course_name'] ?? "Unknown",
            sem: studentData['semester'] != null ? studentData['semester'].toString() : "Unknown",
            div: studentData['division'] ?? "Unknown",
          );
        }).toList();

        setState(() {
          allStudents = fetchedStudents;
          _applyFilters();
        });
      } else {
        print('Failed to load students. Status Code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load students. Status Code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error fetching students: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching students: $e')),
      );
    }
  }

  void _applyFilters() {
    setState(() {
      filteredStudents = allStudents.where((student) {
        return (selectedCourse == "All" || student.course == selectedCourse) &&
            (selectedSemester == "All" || student.sem == selectedSemester) &&
            (selectedDivision == "All" || student.div == selectedDivision);
      }).toList();
      currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredStudents.length / studentsPerPage).ceil();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Students",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A3B87),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildFilters(),

          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(
              child: Text(
                "No Students Available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: getDisplayedItemCount(),
              itemBuilder: (context, index) {
                int studentIndex = currentPage * studentsPerPage + index;
                final student = filteredStudents[studentIndex];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: student.imageUrl != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(student.imageUrl!),
                    )
                        : CircleAvatar(
                      backgroundColor: const Color(0xFF0A3B87),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      student.name,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Course: ${student.course} | Sem: ${student.sem} | Div: ${student.div}",
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                );
              },
            ),
          ),

          if (filteredStudents.length > studentsPerPage) _buildPaginationControls(totalPages),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    List<String> courses = ["All"];
    courses.addAll(allStudents.map((s) => s.course).toSet().toList());

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: [
            _buildDropdown("Course", courses, selectedCourse, (value) {
              selectedCourse = value!;
              _applyFilters();
            }),
            _buildDropdown("Semester", ["All", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"], selectedSemester, (value) {
              selectedSemester = value!;
              _applyFilters();
            }),
            _buildDropdown("Division", ["All", "A", "B", "C"], selectedDivision, (value) {
              selectedDivision = value!;
              _applyFilters();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: currentPage > 0
                  ? () {
                setState(() {
                  currentPage--;
                });
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3B87),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Previous",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Page ${currentPage + 1} of $totalPages",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: currentPage < totalPages - 1
                  ? () {
                setState(() {
                  currentPage++;
                });
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A3B87),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                "Next",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 140,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  int getDisplayedItemCount() {
    int remainingItems = filteredStudents.length - (currentPage * studentsPerPage);
    return remainingItems > studentsPerPage ? studentsPerPage : remainingItems;
  }
}
