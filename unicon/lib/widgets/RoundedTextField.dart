/*
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller; // Add controller
  final Color color;
  final IconData icon;
  final String text;
  final bool privacy;
  final IconData? suffixicon;
  final VoidCallback? togglePasswordVisibility;
  final TextStyle? inputStyle;

  const RoundedTextField({
    required this.controller, // Add controller as required
    required this.color,
    required this.icon,
    required this.text,
    required this.privacy,
    this.suffixicon,
    this.togglePasswordVisibility,
    this.inputStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller, // Bind the controller
        obscureText: privacy,
        style: inputStyle,
        decoration: InputDecoration(
          icon: Icon(icon, color: color),
          hintText: text,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          border: InputBorder.none,
          suffixIcon: suffixicon != null
              ? GestureDetector(
            onTap: togglePasswordVisibility,
            child: Icon(suffixicon, color: color),
          )
              : null,
        ),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';

class RoundedTextField extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final bool privacy;
  final IconData? suffixicon;
  final VoidCallback? togglePasswordVisibility;
  final TextStyle? inputStyle;
  final TextEditingController controller;

  const RoundedTextField({
    required this.color,
    required this.icon,
    required this.text,
    required this.privacy,
    this.suffixicon,
    this.togglePasswordVisibility,
    this.inputStyle,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: privacy, // Toggles between showing and hiding password
        style: inputStyle,
        decoration: InputDecoration(
          icon: Icon(icon, color: color),
          hintText: text,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          border: InputBorder.none,
          suffixIcon: suffixicon != null
              ? GestureDetector(
            onTap: togglePasswordVisibility, // Calls the toggle function
            child: Icon(suffixicon, color: color),
          )
              : null,
        ),
      ),
    );
  }
}
