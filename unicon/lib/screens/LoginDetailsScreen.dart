import 'package:flutter/material.dart';
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
                  "lib/assets/GLS-University.jpg",
                  height: size.height * 0.2,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                // const Text(
                //   "Welcome Back!",
                //   style: TextStyle(
                //     fontSize: 24,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.white,
                //   ),
                // ),
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
                  // Updated RoundedTextField with style enhancements
                  RoundedTextField(
                    color: Colors.grey,
                    icon: Icons.person,
                    text: "Your Username",
                    privacy: false,
                    suffixicon: null,
                    inputStyle: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 10),
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
                  ),
                  const SizedBox(height: 10),

                  // Updated Login Button with Gradient
                  CircularButton(
                    text: "LOGIN",
                    color: Colors.indigoAccent,
                    textColor: Colors.white,
                    // color: const Color(0xff1222ca),
                    press: () {
                      // Handle login
                    },
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
