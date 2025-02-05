/*
import 'package:flutter/material.dart';

class FacultyDashboardScreen extends StatelessWidget {
  final String userName;

  const FacultyDashboardScreen({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Log out functionality goes here
              // For now, just pop the current screen to simulate logout
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to Dashboard, $userName!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:unicon/features/screens/Faculty/faculty_sidemenu.dart';
import '../../../../shared/widgets/faculty_navbar.dart';

class FacultyDashboardScreen extends StatefulWidget {
  final String userName;

  const FacultyDashboardScreen({Key? key, required this.userName}) : super(key: key);

  @override
  _FacultyDashboardScreenState createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onScannerTap() {
    // Handle scanner tap (you can add scanner logic here)
    print("Scanner button tapped!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF0A3B87),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(), // Opens SideMenu
          ),
        ),
      ),
      drawer: faculty_sidemenu(
        onMenuTap: (route) {
          Navigator.pop(context); // Close drawer before navigating
          Navigator.pushNamed(context, route);
        },
        userName: widget.userName,
        userEmail: "johndoe@example.com", // This can be dynamic
      ),
      body: IndexedStack(
        index: _currentIndex, // Display content based on the selected tab
        children: [
          Center(
            child: Text(
              "Dashboard Content",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "Updates Content",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: FacultyNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected, // Handle tab change
        onScannerTap: _onScannerTap, // Handle scanner button tap
      ),
    );
  }
}
