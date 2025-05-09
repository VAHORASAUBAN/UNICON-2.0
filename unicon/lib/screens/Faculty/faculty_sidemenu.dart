import 'package:flutter/material.dart';

import 'facultyprofilescreen.dart'; // Make sure you have a ProfileScreen.dart

class faculty_sidemenu extends StatelessWidget {
  final String userName;
  final String userEmail;
  final Function(String) onMenuTap; // Callback for menu selection

  const faculty_sidemenu({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ==== Header Section ====
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0A3B87), Color(0xFF004AAD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Profile Picture with GestureDetector
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close the drawer first
                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FacultyProfileScreen()),
                      );
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // User Name & Email
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),

          // ==== Academics Section ====
          _buildSectionTitle("Academics"),
          _buildDrawerItem(Icons.groups, "All Students", () => onMenuTap("/allstudent")),
          _buildDrawerItem(Icons.calendar_month_rounded, "Attendance Report", () => onMenuTap("/attendance")),
          const Divider(),

          // ==== Support Section ====
          _buildSectionTitle("Support"),
          _buildDrawerItem(Icons.contact_mail, "Contact Us", () => onMenuTap("/contact")),
          _buildDrawerItem(Icons.help_outline, "Help & Support", () => onMenuTap("/help")),
          const Divider(),

          // ==== App Info Section ====
          _buildSectionTitle("App Info"),
          _buildDrawerItem(Icons.info_outline, "About App", () => onMenuTap("/about")),
          _buildDrawerItem(Icons.privacy_tip, "Privacy Policy", () => onMenuTap("/privacy")),
          const Divider(),

          // ==== Logout Section ====
          _buildDrawerItem(Icons.logout, "Logout", () {
            Navigator.pop(context);
            onMenuTap("/logout");
          }, color: Colors.red),
        ],
      ),
    );
  }

  // ===== Helper Functions =====

  ListTile _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {Color color = const Color(0xFF0A3B87)}) {
    return ListTile(
      tileColor: Colors.white,
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  Padding _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
      ),
    );
  }
}
