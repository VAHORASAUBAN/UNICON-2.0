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
        Uri.parse(Config.allStudents), // Using the Config class here
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        List<Student> fetchedStudents = data.map((studentData) {
          return Student(
            name: "${studentData['firstname'] ?? ''} ${studentData['lastname'] ?? ''}",
            course: studentData['course_name'] ?? "Unknown", // Ensure course_name is used here
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
      body: SingleChildScrollView( // Wrap entire body with SingleChildScrollView
        child: Column(
          children: [
            _buildFilters(),

            // Display a message when no students are found
            if (filteredStudents.isEmpty)
              const Center(
                child: Text(
                  "No Students Available",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
              )
            else
            // List of students with pagination
              ListView.builder(
                shrinkWrap: true, // Let the ListView take only required space
                physics: NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
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

            // Pagination controls at the bottom
            if (filteredStudents.length > studentsPerPage)
              _buildPaginationControls(totalPages),
          ],
        ),
      ),
    );
  }

  // Filter Dropdowns
  Widget _buildFilters() {
    List<String> courses = ["All"];
    courses.addAll(allStudents.map((s) => s.course).toSet().toList());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView( // Add horizontal scrolling to Row
        scrollDirection: Axis.horizontal, // Allow horizontal scrolling
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
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

  // Pagination Controls
  Widget _buildPaginationControls(int totalPages) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: currentPage > 0
                ? () {
              setState(() {
                currentPage--;
              });
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A3B87),
            ),
            child: const Text(
              "Previous",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Text(
            "Page ${currentPage + 1} of $totalPages",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: currentPage < totalPages - 1
                ? () {
              setState(() {
                currentPage++;
              });
            }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A3B87),
            ),
            child: const Text(
              "Next",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Dropdown menu widget
  Widget _buildDropdown(String label, List<String> items, String selectedValue, Function(String?) onChanged) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,  // Set background color to white
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26), // Keeps the border style
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item,
                  child: Text(item),
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
