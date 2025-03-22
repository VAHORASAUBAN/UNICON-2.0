
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _scannerController = MobileScannerController();
  bool isFlashOn = false;
  bool isOtpMode = false; // Toggle between scanner and OTP mode
  String? scannedValue; // Store scanned QR code value
  final TextEditingController _otpController = TextEditingController();

  void _handleScan(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        setState(() {
          scannedValue = code;
        });

        // Navigate to confirmation screen after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ScanSuccessScreen(scannedData: code),
            ),
          );
        });
      }
    }
  }

  void _submitOtp() {
    final String otp = _otpController.text.trim();
    if (otp.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScanSuccessScreen(scannedData: otp),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        backgroundColor: const Color(0xFF0A3B87),
        actions: [
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: isFlashOn ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() {
                isFlashOn = !isFlashOn;
              });
              _scannerController.toggleTorch();
            },
          ),
          IconButton(
            icon: Icon(
              isOtpMode ? Icons.qr_code : Icons.keyboard,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isOtpMode = !isOtpMode;
                scannedValue = null;
                _otpController.clear();
              });
              if (!isOtpMode) {
                _scannerController.start();
              }
            },
          ),
        ],
      ),
      body: isOtpMode ? _buildOtpInput() : _buildScanner(),
      floatingActionButton: isOtpMode
          ? null
          : FloatingActionButton(
        backgroundColor: const Color(0xFF0A3B87),
        onPressed: () {
          setState(() {
            scannedValue = null;
          });
          _scannerController.start();
        },
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildScanner() {
    return Column(
      children: [
        Expanded(
          child: MobileScanner(
            controller: _scannerController,
            onDetect: _handleScan,
          ),
        ),
        if (scannedValue != null)
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            color: Colors.green,
            child: Column(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 40),
                const SizedBox(height: 10),
                Text(
                  "Scanned Successfully!",
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Value: $scannedValue",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Enter OTP",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _otpController,
            decoration: InputDecoration(
              labelText: "OTP",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Submit", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}

class ScanSuccessScreen extends StatelessWidget {
  final String scannedData;

  const ScanSuccessScreen({super.key, required this.scannedData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Confirmed")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                "Attendance Successfully!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Scanned Data:\n$scannedData",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Done", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}