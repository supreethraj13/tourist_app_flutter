import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_tourist/services/api_service.dart';
import 'package:smart_tourist/provider/userprovider.dart';
import 'package:smart_tourist/models/usermodel.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({Key? key}) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final otpController = TextEditingController();
  bool isLoading = false;
  bool isResending = false;
  String errorMessage = '';
  String? email;
  String? fullName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    email = args?['email'];
    fullName = args?['fullName'];
  }

  Future<void> _verifyOTP() async {
    if (otpController.text.length != 6) {
      setState(() {
        errorMessage = 'Please enter 6-digit OTP';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final result = await ApiService.verifyOTP(email!, otpController.text);
      if (result['success']) {
        // Save token and user data
        await ApiService.saveToken(result['data']['data']['token']);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final userData = result['data']['data']['user'];
        userProvider.updateUser(UserModel.fromJson(userData));
        
        // Show enhanced success dialog
        _showEnhancedSuccessDialog(userData['touristId'], result['data']['data']['deliveryStatus']);
      } else {
        setState(() {
          errorMessage = result['data']['message'] ?? 'OTP verification failed';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error. Please check your connection.';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _resendOTP() async {
    setState(() {
      isResending = true;
      errorMessage = '';
    });

    try {
      final result = await ApiService.resendOTP(email!);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text('OTP sent to your email'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() {
          errorMessage = result['data']['message'] ?? 'Failed to resend OTP';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Network error. Please check your connection.';
      });
    }

    setState(() {
      isResending = false;
    });
  }

  // 🎉 ENHANCED Success Dialog with Prominent Tourist ID Display
  void _showEnhancedSuccessDialog(String touristId, Map<String, dynamic>? deliveryStatus) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with celebration
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.blue.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.celebration, color: Colors.white, size: 50),
                      SizedBox(height: 10),
                      Text(
                        '🎉 SUCCESS!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome to Smart Tourist Safety!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                // Tourist ID Display - ALWAYS PROMINENT
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.purple.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.credit_card, color: Colors.white, size: 32),
                      SizedBox(height: 10),
                      Text(
                        'YOUR DIGITAL TOURIST ID',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 5),
                      SelectableText(
                        touristId,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          fontFamily: 'monospace',
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '⚠️ SAVE THIS ID FOR LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action Buttons
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _copyToClipboard(touristId),
                          icon: Icon(Icons.copy, size: 16),
                          label: Text('Copy ID'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.blue),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _shareTouristId(touristId),
                          icon: Icon(Icons.share, size: 16),
                          label: Text('Share'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Delivery Status Information
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.amber.shade800, size: 16),
                          SizedBox(width: 5),
                          Text(
                            'Tourist ID Delivery Status',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      _buildDeliveryStatusItem(
                        '📧 Email',
                        deliveryStatus?['welcomeEmail'] == true || deliveryStatus?['simpleEmail'] == true,
                        'Sent to your registered email address',
                      ),
                      _buildDeliveryStatusItem(
                        '📱 SMS Backup',
                        deliveryStatus?['smsBackup'] == true,
                        'Sent to your mobile number',
                      ),
                      _buildDeliveryStatusItem(
                        '👆 App Display',
                        true,
                        'Tourist ID shown above as backup',
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          '💡 Tip: If emails are delayed, use the Tourist ID shown above to login immediately!',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Continue Button
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 5,
                    ),
                    child: Text(
                      'START USING APP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryStatusItem(String method, bool isSuccess, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.cancel,
            color: isSuccess ? Colors.green : Colors.grey,
            size: 14,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  method,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSuccess ? Colors.green.shade700 : Colors.grey.shade600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copyToClipboard(String touristId) {
    Clipboard.setData(ClipboardData(text: touristId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text('Tourist ID copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareTouristId(String touristId) {
    Share.share(
      'My Smart Tourist Safety ID: $touristId\n\n'
      'Download the app: https://smart-tourist-safety.gov.in/app\n'
      'Stay safe while traveling! 🛡️',
      subject: 'My Digital Tourist ID - Smart Tourist Safety'
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text('Verify Email'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              
              // Header
              Icon(Icons.email_outlined, size: 80, color: Colors.blue),
              SizedBox(height: 24),
              Text(
                'Verify Your Email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'We sent a 6-digit code to\n${email ?? ''}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 40),
              
              // OTP Input
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, letterSpacing: 8),
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: 'Enter 6-digit OTP',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 20),
                  counterText: '', // Hide character counter
                ),
              ),
              SizedBox(height: 16),
              
              // Error message
              if (errorMessage.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red.shade800),
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 24),
              
              // Verify Button
              ElevatedButton(
                onPressed: isLoading ? null : _verifyOTP,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
                ),
                child: isLoading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          ),
                          SizedBox(width: 12),
                          Text('Verifying...', style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text(
                        'VERIFY OTP',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
              SizedBox(height: 24),
              
              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Didn't receive code? "),
                  TextButton(
                    onPressed: isResending ? null : _resendOTP,
                    child: isResending
                        ? Text('Sending...')
                        : Text('Resend OTP', style: TextStyle(fontWeight: FontWeight.bold)),
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
