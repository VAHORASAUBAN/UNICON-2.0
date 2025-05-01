import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../services/Config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentProfile();
  }

  Future<void> fetchStudentProfile() async {
    const url = Config.studentProfile; // change if hosted
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"student_id": 1}), // Replace with actual student ID
    );

    if (response.statusCode == 200) {
      setState(() {
        studentData = jsonDecode(response.body);
        isLoading = false;
      });
    } else {
      // Handle error
      print("Failed to fetch: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildProfileImage(),
                  const SizedBox(height: 12),
                  _buildEmail(),
                  const SizedBox(height: 25),
                  _buildInfoTile(Icons.person, 'First Name', studentData?['firstname']?.toString() ?? ''),
                  _buildInfoTile(Icons.person_outline, 'Middle Name', studentData?['middlename']?.toString() ?? ''),
                  _buildInfoTile(Icons.person, 'Last Name', studentData?['lastname']?.toString() ?? ''),
                  _buildInfoTile(Icons.apartment, 'Department', studentData?['student_department']?.toString() ?? 'Unknown Department'),
                  _buildInfoTile(Icons.menu_book, 'Course', studentData?['course']?.toString() ?? 'Unknown Course'),
                  _buildInfoTile(Icons.timeline, 'Semester', studentData?['semester']?.toString() ?? ''),
                  _buildInfoTile(Icons.group, 'Division', studentData?['division']?.toString() ?? ''),
                  _buildInfoTile(Icons.male, 'Gender', studentData?['gender']?.toString() ?? ''),
                  _buildInfoTile(Icons.phone, 'Mobile', studentData?['mobile_number']?.toString() ?? ''),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A3B87), Color(0xFF004AAD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: const Text(
                "Student Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    final imageUrl = studentData?['student_image'];
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundImage: imageUrl != null
            ? NetworkImage(imageUrl)
            : const AssetImage('assets/images/profile.png') as ImageProvider,
      ),
    );
  }

  Widget _buildEmail() {
    return Text(
      studentData?['email'] ?? '',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF004AAD),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF004AAD)),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0A3B87),
            ),
          ),
        ],
      ),
    );
  }
}
