import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

import '../../widgets/AttendancePieChart.dart';

class AttendanceReport extends StatefulWidget {
  const AttendanceReport({Key? key}) : super(key: key);

  @override
  _AttendanceReportState createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  DateTime selectedDate = DateTime.now();
  final List<String> months = List.generate(12, (index) => DateFormat.MMMM().format(DateTime(0, index + 1)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Attendance Report"),
        backgroundColor: const Color(0xFF0A3B87),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.y().format(selectedDate),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: DateFormat.MMMM().format(selectedDate),
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Color(0xFF0A3B87)),
                  underline: Container(
                    height: 2,
                    color: const Color(0xFF0A3B87),
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDate = DateTime(selectedDate.year, months.indexOf(newValue!) + 1);
                    });
                  },
                  items: months.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Attendance Pie Chart
            AttendancePieChart(),
            const SizedBox(height: 24),

            // Subject Activity Section
            const Text(
              "Subject Activity",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            _buildSubjectCard("CNS", "80%", "18/20", Colors.green[500]!),
            _buildSubjectCard("FLUTTER", "60%", "14/20", Colors.yellow[500]!),
            _buildSubjectCard("ADS", "40%", "8/20", Colors.red[500]!),
            _buildSubjectCard("MLP", "80%", "18/20", Colors.green[500]!),
            _buildSubjectCard("ECC", "80%", "18/20", Colors.green[500]!),
          ],
        ),
      ),
    );
  }

  // Subject Card
  Widget _buildSubjectCard(String subject, String percentage, String sessions, Color percentageColor) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Sessions Attended', style: TextStyle(color: Colors.grey[500])),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(percentage, style: TextStyle(color: percentageColor, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(sessions, style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}