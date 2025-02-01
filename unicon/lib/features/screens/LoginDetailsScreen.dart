import 'package:flutter/material.dart';
import 'package:unicon/features/screens/dashboard/DashboardScreen.dart';
import '../../../services/AuthService.dart';
import '../../shared/widgets/CircularButton.dart';
import '../../shared/widgets/RoundedTextField.dart';
import 'sidemenu.dart';


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
    print("HandleLogin: Username -> $username, Password -> $password"); // Debug

    setState(() {
      _isLoading = true;
    });

    bool success = await AuthService.login(username, password);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      print("HandleLogin: Redirecting to Dashboard");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      print("HandleLogin: Showing invalid credentials snackbar");
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
          // Solid Background Color
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
                  "assets/images/GLS.png",
                  height: size.height * 0.3,
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
                    'Sign In',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Subheading: Sign in to my account
                  const Text(
                    'Sign in to my account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Username Field
                  RoundedTextField(
                    controller: _usernameController, // Pass the username controller
                    color: Colors.grey,
                    icon: Icons.person,
                    text: "Your Username",
                    privacy: false,
                    suffixicon: null,
                    inputStyle: const TextStyle(color: Colors.black),
                  ),

// Password Field
                  RoundedTextField(
                    color: Colors.grey,
                    icon: Icons.lock,
                    text: "Your Password",
                    privacy: !_isPasswordVisible, // Control visibility based on state
                    suffixicon: _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    togglePasswordVisibility: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
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
