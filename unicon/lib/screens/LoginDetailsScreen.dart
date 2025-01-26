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
          // Solid Background Color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF0A3B87), // Replaced with the provided color
          ),

          // Centered Logo, moved upwards
          Align(
            alignment: Alignment(0, -0.4), // Moves logo upwards
            child: Column(
              children: [
                Image.asset(
                  "assets/GLS.png",
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
                  // Sign In Heading
                  const Text(
                    'Sign In',  // Main heading text
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,  // Text color set to black
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subheading: Sign in to my account
                  const Text(
                    'Sign in to my account',  // Subheading text
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,  // Slightly lighter black for subheading
                    ),
                  ),
                  const SizedBox(height: 20),

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

                  // Forgot Password Link aligned to the left
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Handle forgot password action
                          // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen()));
                        },
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

                  // Login Button or Loading Indicator with updated color
                  _isLoading
                      ? const CircularProgressIndicator()
                      : CircularButton(
                    text: "LOGIN",
                    color: const Color(0xFF0A3B87), // Updated to match background color
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
