import 'package:flutter/material.dart';

class CompanyDetailsScreen extends StatelessWidget {
  final Map<String, String> company;

  const CompanyDetailsScreen({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(company["name"]!),
        backgroundColor: const Color(0xFF0A3B87),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 22),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // **Company Logo**
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(company["logo"]!),
              ),
            ),
            const SizedBox(height: 20),

            // **Company Name**
            Center(
              child: Text(
                company["name"]!,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),

            // **Details Section**
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow("Role", company["role"]!),
                    _buildDetailRow("Location", company["location"]!),
                    _buildDetailRow("Package", company["package"]!),
                    _buildDetailRow("Application Deadline", company["deadline"]!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // **Apply Now Button**
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle Apply Action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Apply Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // **Helper Method for Detail Row**
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 16, color: Colors.blueGrey.shade700)),
        ],
      ),
    );
  }
}
