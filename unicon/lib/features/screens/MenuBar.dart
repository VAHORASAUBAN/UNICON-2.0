import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:unicon/features/screens/timetable_screen.dart';

import '../../shared/widgets/navbar.dart'; // Import the TimetableService

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    DashboardContent(),
    UpdatesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87),
        elevation: 0,
        title: const Text("Dashboard", style: TextStyle(color: Colors.white)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ==== Header Section ====
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0A3B87), Color(0xFF004AAD)], // Gradient effect
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20), // Space before profile

                  Container(
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
                      radius: 35, // Adjust size as needed
                      backgroundImage: AssetImage('assets/images/profile.png'), // Local image
                    ),
                  ),
                  const SizedBox(height: 12), // Space before username

                  // Username with Custom Style
                  const Text(
                    'User Name', // Replace dynamically if needed
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'user.email@example.com', // Optional user email
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // ==== Academics Section ====
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                "Academics",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, color: Color(0xFF0A3B87)),
              title: const Text("Timetable"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.assignment, color: Color(0xFF0A3B87)),
              title: const Text("Attendance Report"),
              onTap: () {},
            ),
            const Divider(),

            // ==== Support Section ====
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                "Support",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail, color: Color(0xFF0A3B87)),
              title: const Text("Contact Us"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Color(0xFF0A3B87)),
              title: const Text("Help & Support"),
              onTap: () {},
            ),
            const Divider(),

            // ==== App Info Section ====
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                "App Info",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF0A3B87)),
              title: const Text("About App"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Color(0xFF0A3B87)),
              title: const Text("Privacy Policy"),
              onTap: () {},
            ),
            const Divider(),

            // ==== Logout Section ====
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () {},
            ),
          ],
        ),
      ),


      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            if (index >= 0 && index < _screens.length) {
              _currentIndex = index;
            }
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A3B87),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int screenIndex) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0A3B87)),
      title: Text(title),
      onTap: () {
        if (screenIndex == -1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => TimetableScreen()));
        } else if (screenIndex >= 0) {
          setState(() {
            if (screenIndex < _screens.length) {
              _currentIndex = screenIndex;
            }
          });
          Navigator.pop(context);
        } else {
          // Handle other actions (like logout, update password, etc.)
          Navigator.pop(context);
        }
      },
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(today);

    // Fetch today's timetable from TimetableService
    final List<Subject> todaysTimetable = TimetableService.getTodaysTimetable();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Timetable for $formattedDate:',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (todaysTimetable.isEmpty)
            const Text("No classes today.")
          else
            ...todaysTimetable.map((subject) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Image.asset("assets/images/GLS.png", width: 40, height: 40), // Placeholder image
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subject.name, style: const TextStyle(fontSize: 16)), // Subject name
                      Text(subject.timeRange, style: const TextStyle(fontSize: 14, color: Colors.grey)), // Subject time
                    ],
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}

class UpdatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Updates Screen"));
  }
}

class QRCodeScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Updates Screen"));
  }
}
