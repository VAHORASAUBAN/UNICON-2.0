import 'package:flutter/material.dart';
import '../../../shared/widgets/navbar.dart';
import '../sidemenu.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0; // Track the selected tab index

  // Function to handle tab selection
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Function for scanner button tap (open QR scanner or something else)
  void _onScannerTap() {
    // Handle QR Scanner tap (can be a new screen or modal)
    print('Scanner tapped');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: const Color(0xFF0A3B87),
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 24),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(), // Opens SideMenu
          ),
        ),
      ),
      drawer: sidemenu(
        onMenuTap: (route) {
          Navigator.pop(context); // Close drawer before navigating
          Navigator.pushNamed(context, route);
        },
        userName: "John Doe",
        userEmail: "johndoe@example.com",
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
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabSelected, // Handle tab change
        onScannerTap: _onScannerTap, // Handle scanner button tap
      ),
    );
  }
}
