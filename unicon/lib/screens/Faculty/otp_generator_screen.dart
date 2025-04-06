import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class OTPGeneratorScreen extends StatefulWidget {
  const OTPGeneratorScreen({Key? key}) : super(key: key);

  @override
  _OTPGeneratorScreenState createState() => _OTPGeneratorScreenState();
}

class _OTPGeneratorScreenState extends State<OTPGeneratorScreen> {
  String? otp;
  bool isOtpActive = false;
  Timer? otpTimer;
  int remainingTime = 30; // OTP expires in 30 seconds

  void _generateOTP() {
    if (!isOtpActive) {
      setState(() {
        otp = _generateRandomOTP();
        isOtpActive = true;
        remainingTime = 30;
      });

      print("Generated OTP: $otp"); // Debugging

      // Start 30-second countdown
      otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (remainingTime > 0) {
            remainingTime--;
            print("Remaining Time: $remainingTime"); // Debugging
          } else {
            otp = null; // Expire OTP
            isOtpActive = false;
            timer.cancel();
            print("OTP Expired"); // Debugging
          }
        });
      });
    }
  }

  String _generateRandomOTP() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString(); // 6-digit OTP
  }

  @override
  void dispose() {
    otpTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ White background
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A3B87), // Dark blue app bar
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Generate OTP',
          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Colors.white, // ✅ White background for the entire body
        padding: const EdgeInsets.all(20), // Added padding for better UI
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (otp != null) ...[
                const Text(
                  'Your OTP:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                Text(
                  otp!,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.red),
                ),
                Text(
                  'Expires in: $remainingTime sec',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),
              ],
              ElevatedButton(
                onPressed: _generateOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3B87), // ✅ Button background color
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Generate OTP',
                  style: TextStyle(color: Colors.white, fontSize: 18), // ✅ White text
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
