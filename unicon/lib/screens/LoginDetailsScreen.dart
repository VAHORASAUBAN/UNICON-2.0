import 'package:flutter/material.dart';
import 'package:unicon/screens/student/dashboard/DashboardScreen.dart';
import '../../../services/AuthService.dart';
import '../../widgets/CircularButton.dart';
import '../../widgets/RoundedTextField.dart';
import 'Faculty/dashboard/faculty_dashboard_screen.dart';

class LoginDetailsScreen extends StatefulWidget {
  final String userType;  // Receiving userType from the previous screen

  const LoginDetailsScreen({super.key, required this.userType});

  @override
  _LoginDetailsScreenState createState() => _LoginDetailsScreenState();
}

class _LoginDetailsScreenState extends State<LoginDetailsScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Handle Login Logic
  Future<void> _handleLogin() async {
    String enrollment = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    bool success = await AuthService.login(enrollment, password, widget.userType);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      if (widget.userType == 'Student') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else if (widget.userType == 'Faculty') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FacultyDashboardScreen(userName: 'Faculty')),
        );
      }
    } else {
      _showSnackBar("Invalid login credentials");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF0A3B87),
          ),
          Align(
            alignment: Alignment(0, 0.10),
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/unicon_logo.png",
                  height: size.height * 0.3,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Sign in to my account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RoundedTextField(
                    controller: _usernameController,
                    color: Colors.grey,
                    icon: Icons.person,
                    text: "Enrollment Number",
                    privacy: false,
                    suffixicon: null,
                    inputStyle: const TextStyle(color: Colors.black),
                  ),
                  RoundedTextField(
                    color: Colors.grey,
                    icon: Icons.lock,
                    text: "Your Password",
                    privacy: !_isPasswordVisible,
                    suffixicon: _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    togglePasswordVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    inputStyle: const TextStyle(color: Colors.black),
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : CircularButton(
                    text: "LOGIN",
                    color: const Color(0xFF0A3B87),
                    textColor: Colors.white,
                    press: _handleLogin,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
