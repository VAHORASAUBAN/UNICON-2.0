import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onScannerTap; // Function for Scanner button

  const CustomNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.onScannerTap, // Pass function for scanner tap
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allows button to float outside navbar
      children: [
        // Bottom Navigation Bar
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Updates',
            ),
          ],
          selectedItemColor: const Color(0xFF0A3B87),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),

        // Scanner Floating Button in Center
        Positioned(
          top: -20, // Adjust height to make it float
          left: MediaQuery.of(context).size.width / 2 - 30, // Center align
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF0A3B87), // Button color
            onPressed: onScannerTap, // Callback function for scan button
            child: const Icon(Icons.qr_code_scanner, color: Colors.white), // Scanner icon
            shape: const CircleBorder(), // Circular shape
            elevation: 6, // Adds shadow effect
          ),
        ),
      ],
    );
  }
}
