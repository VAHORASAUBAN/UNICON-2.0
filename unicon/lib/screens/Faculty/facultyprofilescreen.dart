import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../services/AuthService.dart';
import '../../services/Config.dart';

class FacultyProfileScreen extends StatefulWidget {
  const FacultyProfileScreen({super.key});

  @override
  State<FacultyProfileScreen> createState() => _FacultyProfileScreenState();
}

class _FacultyProfileScreenState extends State<FacultyProfileScreen> {
  Map<String, dynamic>? facultyData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFacultyProfile();
  }

  Future<void> fetchFacultyProfile() async {
    const url = Config.teacherProfile; // Update URL if necessary
    try {

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"faculty_id": AuthService.facultyId}),
        // Replace with actual faculty_id
      );

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");  // Debugging line

        if (mounted) {
          setState(() {
            // Parse the response as a list of dynamic objects
            List<dynamic> responseList = jsonDecode(response.body);
            if (responseList.isNotEmpty) {
              facultyData = Map<String, dynamic>.from(responseList[0]);  // Convert the first element to a Map
            } else {
              facultyData = {};  // Empty data if the list is empty
            }
            isLoading = false;
          });
        }
      } else {
        print("Failed to fetch: ${response.body}");
      }
    } catch (e) {
      print("Error fetching profile: $e");
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
                  _buildInfoTile(Icons.person, 'First Name', facultyData?['firstname'] ?? ''),
                  _buildInfoTile(Icons.person_outline, 'Middle Name', facultyData?['middlename'] ?? ''),
                  _buildInfoTile(Icons.person, 'Last Name', facultyData?['lastname'] ?? ''),
                  _buildInfoTile(Icons.apartment, 'Department', facultyData?['department']['department_name'] ?? 'Unknown Department'),
                  _buildInfoTile(Icons.menu_book, 'Course', facultyData?['course']['course_name'] ?? 'Unknown Course'),
                  _buildInfoTile(Icons.work, 'Designation', facultyData?['designations'] ?? ''),
                  _buildInfoTile(Icons.school, 'Qualification', facultyData?['qualification'] ?? ''),
                  _buildInfoTile(Icons.military_tech, 'Achievements', facultyData?['achievements'] ?? ''),
                  _buildInfoTile(Icons.male, 'Gender', facultyData?['gender'] ?? ''),
                  _buildInfoTile(Icons.phone, 'Mobile Number', facultyData?['mobile_number'] ?? ''),
                  _buildInfoTile(Icons.calendar_today, 'Birth Date', facultyData?['birth_date'] ?? ''),
                  _buildInfoTile(Icons.date_range, 'Joining Date', facultyData?['joining_date'] ?? ''),
                  _buildInfoTile(Icons.location_city, 'City', facultyData?['city'] ?? ''),
                  _buildInfoTile(Icons.location_on, 'State', facultyData?['state'] ?? ''),
                  _buildInfoTile(Icons.flag, 'Country', facultyData?['country'] ?? ''),
                  _buildInfoTile(Icons.location_pin, 'Pincode', facultyData?['pincode'] ?? ''),
                  _buildInfoTile(Icons.home, 'Address Line 1', facultyData?['address_line_1'] ?? ''),
                  _buildInfoTile(Icons.home_outlined, 'Address Line 2', facultyData?['address_line_2'] ?? ''),
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
                "Faculty Profile",
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
    final imageUrl = facultyData?['pic'];
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
        backgroundImage: imageUrl != null && imageUrl.isNotEmpty
            ? NetworkImage(imageUrl)
            : const AssetImage('assets/images/profile.png') as ImageProvider,
      ),
    );
  }

  Widget _buildEmail() {
    return Text(
      facultyData?['email'] ?? '',
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
