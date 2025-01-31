/*
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'UserName',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage(
                  'assets/images/profile.png'),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Text('Profile'),
              ),
              PopupMenuItem(
                value: 'update_password',
                child: Text('Update Password'),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) {
              // Handle menu actions
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            _buildGridItem('Timetable','assets/images/timetable.jpg'),
            _buildGridItem('Attendance Report','assets/images/attendance.jpg'),
            _buildGridItem('Events','assets/images/events.jpg'),
            _buildGridItem('Placement','assets/images/placement.png'),
            _buildGridItem('Mentorship','assets/images/mentor.jpg'),
            _buildGridItem('Article/Blog','assets/images/article.jpg'),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF002D72),
        child: Icon(Icons.add, size: 30),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildGridItem(String title, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            imageUrl,
            height: 50,
            width: 50,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.broken_image,
              size: 50,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
*/
/*import 'package:flutter/material.dart';
import '../../../shared/widgets/navbar.dart'; // Make sure the path is correct.


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Define your screens for navigation
  final List<Widget> _screens = [
    DashboardContent(),
    QRCodeScannerScreen(),
    UpdatesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87),
        elevation: 0,
        automaticallyImplyLeading: false,  // Removes the default back button
        title: Text("Dashboard",style:TextStyle(color: Colors.white),),  // Removes the title text
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu actions (Profile, Update Password, Logout)
              if (value == 'profile') {
                // Handle Profile action
                print('Navigating to Profile...');
              } else if (value == 'update_password') {
                // Handle Update Password action
                print('Navigating to Update Password...');
              } else if (value == 'logout') {
                // Handle Logout logic
                print('Logging out...');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: "profile", child: Text("Profile")),
              const PopupMenuItem(value: "update_password", child: Text("Update Password")),
              const PopupMenuItem(value: "logout", child: Text("Logout")),
            ],
            icon: const Icon(Icons.person, color: Colors.white), // Profile icon
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0A3B87),
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        onPressed: () {
          // Navigate to the QR Code Scanner screen when pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: const [
          DashboardTile(icon: Icons.calendar_today, label: "Timetable"),
          DashboardTile(icon: Icons.assignment, label: "Attendance Report"),
          DashboardTile(icon: Icons.event, label: "Events"),
          DashboardTile(icon: Icons.work, label: "Placement"),
          DashboardTile(icon: Icons.group, label: "Mentorship"),
          DashboardTile(icon: Icons.article, label: "Article/Blog"),
        ],
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const DashboardTile({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: const Color(0xFF0A3B87)),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class QRCodeScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("QR Code Scanner Screen")),
    );
  }
}

class UpdatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Updates Screen")),
    );
  }
}*/
/*import 'package:flutter/material.dart';
import '../../../shared/widgets/navbar.dart';
import 'package:unicon/features/screens/timetable_screen.dart'; // Import TimetableScreen from timetable_screen.dart

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  // Define screens for navbar navigation
  final List<Widget> _screens = [
    DashboardContent(),  // Dashboard content
    UpdatesScreen(),     // Updates screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87),
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          "Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white), // Hamburger icon
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
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF0A3B87),
              ),
              child: const Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(Icons.calendar_today, "Timetable", -1), // Timetable accessible only from drawer
            _buildDrawerItem(Icons.assignment, "Attendance Report", 1),
            _buildDrawerItem(Icons.event, "Events", 2),
            _buildDrawerItem(Icons.work, "Placement", 3),
            _buildDrawerItem(Icons.group, "Mentorship", 4),
            _buildDrawerItem(Icons.article, "Article/Blog", 5),
            const Divider(),
            _buildDrawerItem(Icons.person, "Profile", -2),
            _buildDrawerItem(Icons.lock, "Update Password", -3),
            _buildDrawerItem(Icons.logout, "Logout", -4),
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
          // Timetable screen logic (open via drawer only)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TimetableScreen()), // Navigate to TimetableScreen
          );
        } else if (screenIndex >= 0) {
          setState(() {
            if (screenIndex < _screens.length) {
              _currentIndex = screenIndex;
            }
          });
          Navigator.pop(context);
        } else {
          print('Action for: $title'); // Handle other drawer actions
          Navigator.pop(context);
        }
      },
    );
  }
}

class DashboardContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Dashboard Content will go here."),
    );
  }
}

class UpdatesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Updates Screen"),
    );
  }
}

class QRCodeScannerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("QR Code Scanner Screen"),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:unicon/features/screens/timetable_screen.dart';

import '../../../shared/widgets/navbar.dart'; // Import the TimetableService

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
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF0A3B87),
              ),
              child: const Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _buildDrawerItem(Icons.calendar_today, "Timetable", -1),
            _buildDrawerItem(Icons.assignment, "Attendance Report", 1),
            _buildDrawerItem(Icons.event, "Events", 2),
            _buildDrawerItem(Icons.work, "Placement", 3),
            _buildDrawerItem(Icons.group, "Mentorship", 4),
            _buildDrawerItem(Icons.article, "Article/Blog", 5),
            const Divider(),
            _buildDrawerItem(Icons.person, "Profile", -2),
            _buildDrawerItem(Icons.lock, "Update Password", -3),
            _buildDrawerItem(Icons.logout, "Logout", -4),
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
