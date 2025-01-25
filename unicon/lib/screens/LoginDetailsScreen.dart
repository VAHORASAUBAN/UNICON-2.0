import 'package:flutter/material.dart';
import 'package:unicon/screens/Dashboard.dart';
import '../services/AuthService.dart';
import '../widgets/RoundedTextField.dart';
import '../widgets/CircularButton.dart';

class LoginDetailsScreen extends StatefulWidget {
  final String userType;

  const LoginDetailsScreen({required this.userType});

  @override
  _LoginDetailsScreenState createState() => _LoginDetailsScreenState();
}

class _LoginDetailsScreenState extends State<LoginDetailsScreen> {
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    bool success = await AuthService.login(username, password);
    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
      // _showSnackBar("Invalid login credentials");
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
          // Gradient Background
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff1e44e3), Color(0xFF4500BC)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Centered Logo
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/GLS-University.jpg",
                  height: size.height * 0.2,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          // Input Fields Card at Bottom
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
                  // Username Field
                  RoundedTextField(
                    color: Colors.grey,
                    icon: Icons.person,
                    text: "Your Username",
                    privacy: false,
                    suffixicon: null,
                    inputStyle: const TextStyle(color: Colors.black),
                    controller: _usernameController,
                  ),
                  const SizedBox(height: 10),

                  // Password Field
                  RoundedTextField(
                    color: Colors.grey,
                    icon: Icons.lock,
                    text: "Your Password",
                    privacy: true,
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

                  // Login Button or Loading Indicator
                  _isLoading
                      ? const CircularProgressIndicator()
                      : CircularButton(
                    text: "LOGIN",
                    color: const Color(0xff1222ca),
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