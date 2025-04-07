import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final String profileImage = 'assets/images/profile.png';
  final String email = "student@example.com";
  final String firstName = "Aarav";
  final String middleName = "Kumar";
  final String lastName = "Sharma";
  final String department = "Computer Science";
  final String course = "B.Tech";
  final String semester = "6";
  final String division = "B";
  final String gender = "Male";
  final String mobile = "+91 9876543210";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
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
                  _buildInfoTile(Icons.person, 'First Name', firstName),
                  _buildInfoTile(Icons.person_outline, 'Middle Name', middleName),
                  _buildInfoTile(Icons.person, 'Last Name', lastName),
                  _buildInfoTile(Icons.apartment, 'Department', department),
                  _buildInfoTile(Icons.menu_book, 'Course', course),
                  _buildInfoTile(Icons.timeline, 'Semester', semester),
                  _buildInfoTile(Icons.group, 'Division', division),
                  _buildInfoTile(Icons.male, 'Gender', gender),
                  _buildInfoTile(Icons.phone, 'Mobile', mobile),
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
        backgroundImage: AssetImage(profileImage),
      ),
    );
  }

  Widget _buildEmail() {
    return Text(
      email,
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
          Icon(icon, color: Color(0xFF004AAD)),
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
