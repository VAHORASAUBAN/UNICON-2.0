import 'package:flutter/material.dart';

// Student Model
class Student {
  final String name;
  final String course;
  final String sem;
  final String div;

  Student({required this.name, required this.course, required this.sem, required this.div});
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
    _generateStudents();
    _applyFilters();
  }

  // ✅ Generate students with only 3 semesters: "1", "2", "3"
  void _generateStudents() {
    List<String> courses = ["B.Tech", "BCA", "B.Sc", "BBA"];
    List<String> semesters = ["1", "2", "3"]; // ✅ Only 3 semesters
    List<String> divisions = ["A", "B", "C"];

    for (String course in courses) {
      for (String sem in semesters) {
        for (String div in divisions) {
          for (int i = 1; i <= 50; i++) {  // ✅ Limited student count for better performance
            allStudents.add(Student(
              name: "Student $i",
              course: course,
              sem: sem,
              div: div,
            ));
          }
        }
      }
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
                    leading: CircleAvatar(
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

  // ✅ Improved filter section with a white background for dropdowns
  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDropdown("Course", ["All", "B.Tech", "BCA", "B.Sc", "BBA"], selectedCourse, (value) {
            selectedCourse = value!;
            _applyFilters();
          }),
          _buildDropdown("Semester", ["All", "1", "2", "3"], selectedSemester, (value) { // ✅ Only 3 semesters
            selectedSemester = value!;
            _applyFilters();
          }),
          _buildDropdown("Division", ["All", "A", "B", "C"], selectedDivision, (value) {
            selectedDivision = value!;
            _applyFilters();
          }),
        ],
      ),
    );
  }

  // ✅ Pagination Controls
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

  // ✅ Dropdown with white background
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
            color: Colors.white,  // ✅ White background
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black26),
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

  // ✅ Ensure pagination never sets count to zero
  int getDisplayedItemCount() {
    int remainingItems = filteredStudents.length - (currentPage * studentsPerPage);
    return remainingItems > studentsPerPage ? studentsPerPage : remainingItems;
  }
}
