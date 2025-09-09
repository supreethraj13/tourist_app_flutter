import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourist/models/usermodel.dart';
import 'package:smart_tourist/provider/userprovider.dart';

class Loginscreen extends StatelessWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final TextEditingController touristIdController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and Title
                Image.asset(
                  'lib/assets/imgs/tourist_app_logo.jpg',
                  height: 80,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.security, size: 80, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tourist Safety Monitor',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter your details to start safe travelling',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),

                //const SizedBox(height: 16),
                _buildTextField(
                  label: 'BlockChain Id',
                  controller: touristIdController,
                  keyboardType: TextInputType.text,
                ),

                //const SizedBox(height: 16),
                const SizedBox(height: 40),
                // Start Monitoring Button
                ElevatedButton(
                  onPressed: () {
                    // Update user model in provider
                    final user = userProvider.user;
                    userProvider.updateUser(
                      UserModel(touristId: touristIdController.text),
                    );
                    // Navigate to Home Screen
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A55E1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
