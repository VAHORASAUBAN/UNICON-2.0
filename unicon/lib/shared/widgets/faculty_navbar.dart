/*
import 'package:flutter/material.dart';

import '../../features/screens/student/scanner/scanner_screen.dart';

class FacultyNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onScannerTap; // Function for Scanner button

  const FacultyNavBar({
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
            backgroundColor: const Color(0xFF0A3B87),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const ScannerScreen()),
              // );
            },
            child: const Icon(Icons.add, color: Colors.white), // Scanner icon
            shape: const CircleBorder(), // Circular shape
            elevation: 6, // Adds shadow effect
          ),
        ),
      ],
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:unicon/features/screens/Faculty/dashboard/Otp/otp_generator_screen.dart';
import 'package:unicon/features/screens/Faculty/TimeTable/time_table.dart'; // Import TimeTable screen

class FacultyNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onScannerTap;

  const FacultyNavBar({
    required this.currentIndex,
    required this.onTap,
    required this.onScannerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == 1) { // If "TimeTable" is clicked
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FacultyTimetableScreen()),
              );
            } else {
              onTap(index); // Keep other tabs working normally
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule),
              label: 'TimeTable',
            ),
          ],
          selectedItemColor: const Color(0xFF0A3B87),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        ),

        // Floating plus button in the center
        Positioned(
          top: -20,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: FloatingActionButton(
            backgroundColor: const Color(0xFF0A3B87),
            onPressed: () {
              Navigator.pushNamed(context, '/otpGenerator');
            },
            shape: const CircleBorder(),
            elevation: 6,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
