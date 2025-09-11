import 'dart:async'; // Required for the Timer
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

// Converted to a StatefulWidget to manage the timer's state.
class QrDisplayScreen extends StatefulWidget {
  const QrDisplayScreen({super.key});

  @override
  State<QrDisplayScreen> createState() => _QrDisplayScreenState();
}

class _QrDisplayScreenState extends State<QrDisplayScreen> {
  late Timer _timer;
  int _secondsRemaining = 300; // 5 minutes = 300 seconds

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    // Create a periodic timer that fires every second.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        // If time is left, decrement the counter and update the UI.
        setState(() {
          _secondsRemaining--;
        });
      } else {
        // If the timer reaches zero, cancel it.
        _timer.cancel();
        // Use `mounted` check to ensure the widget is still in the tree.
        if (mounted) {
          // Navigate to the '/home' route, replacing this screen.
          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    });
  }

  @override
  void dispose() {
    // It's crucial to cancel the timer when the widget is disposed.
    _timer.cancel();
    super.dispose();
  }

  // Helper function to format the remaining seconds into a "MM:SS" string.
  String _formatDuration(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    // padLeft ensures the string is 2 digits, e.g., '05' instead of '5'.
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    const String qrDataString = "ThisIsAnAlphanumericString12345";

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF), // Light background
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container to give the QR code a nice card-like look.
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFF1E3A8A,
                    ), // Dark blue background for QR
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qrDataString,
                    version: QrVersions.auto,
                    size: 280.0,
                    // Colors adjusted for contrast against the dark blue background.
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'This code will expire in:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54, // Adjusted for light background
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDuration(
                    _secondsRemaining,
                  ), // Display the formatted time
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black87, // Adjusted for light background
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
