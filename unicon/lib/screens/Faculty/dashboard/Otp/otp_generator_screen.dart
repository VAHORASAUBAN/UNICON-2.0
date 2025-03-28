import 'package:flutter/material.dart';
import 'dart:math';

class OTPGeneratorScreen extends StatefulWidget {
  const OTPGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<OTPGeneratorScreen> createState() => _OTPGeneratorScreenState();
}

class _OTPGeneratorScreenState extends State<OTPGeneratorScreen> {
  String? _generatedOTP;

  // Function to generate a 6-digit OTP
  String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit number
  }

  void _handleGenerateOTP() {
    setState(() {
      _generatedOTP = generateOTP();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Generate OTP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Click the button below to generate OTP for attendance:',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleGenerateOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3B87),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Generate OTP'),
              ),
              const SizedBox(height: 40),
              if (_generatedOTP != null)
                Column(
                  children: [
                    const Text(
                      'Generated OTP:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _generatedOTP!,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A3B87),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
