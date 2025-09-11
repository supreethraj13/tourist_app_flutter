import 'package:flutter/material.dart';
import 'package:smart_tourist/services/api_service.dart';

class Registerscreen extends StatefulWidget {
  const Registerscreen({Key? key}) : super(key: key);

  @override
  State<Registerscreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Registerscreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String errorMessage = '';

  // Controllers for form fields
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final nationalityController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final emergencyNameController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final emergencyRelationController = TextEditingController();
  final aadharController = TextEditingController();

  Future<void> _registerTourist() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final registrationData = {
        'fullName': fullNameController.text,
        'email': emailController.text,
        'mobileNumber': mobileController.text,
        'nationality': nationalityController.text,
        'age': ageController.text,
        'gender': genderController.text,
        'emergencyContactName': emergencyNameController.text,
        'emergencyContactPhone': emergencyPhoneController.text,
        'emergencyContactRelation': emergencyRelationController.text,
        'aadharNumber': aadharController.text,
        'govIdType': 'AADHAR',
        'validFrom': DateTime.now().millisecondsSinceEpoch,
        'validTo': DateTime.now()
            .add(Duration(days: 30))
            .millisecondsSinceEpoch,
      };

      final result = await ApiService.register(registrationData);

      if (result['success']) {
        // Navigate to OTP verification
        Navigator.pushNamed(
          context,
          '/verify-otp',
          arguments: {
            'email': emailController.text,
            'fullName': fullNameController.text,
          },
        );
      } else {
        setState(() {
          errorMessage = result['data']['message'] ?? 'Registration failed';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: Text('Register as New Tourist'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Icon(Icons.person_add, size: 80, color: Colors.blue),
                SizedBox(height: 16),
                Text(
                  'Create Your Tourist Safety Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Register to get your Digital Tourist ID',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 32),

                // Personal Information
                Text(
                  'Personal Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                _buildTextField(
                  'Full Name *',
                  fullNameController,
                  required: true,
                ),
                _buildTextField(
                  'Email *',
                  emailController,
                  keyboardType: TextInputType.emailAddress,
                  required: true,
                ),
                _buildTextField(
                  'Mobile Number *',
                  mobileController,
                  keyboardType: TextInputType.phone,
                  required: true,
                ),
                _buildTextField('Nationality', nationalityController),
                _buildTextField(
                  'Age',
                  ageController,
                  keyboardType: TextInputType.number,
                ),
                _buildTextField('Gender', genderController),
                _buildTextField(
                  'Aadhar Number *',
                  aadharController,
                  keyboardType: TextInputType.number,
                  required: true,
                ),

                SizedBox(height: 24),
                Text(
                  'Emergency Contact *',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                _buildTextField(
                  'Emergency Contact Name *',
                  emergencyNameController,
                  required: true,
                ),
                _buildTextField(
                  'Emergency Phone *',
                  emergencyPhoneController,
                  keyboardType: TextInputType.phone,
                  required: true,
                ),
                _buildTextField(
                  'Relation *',
                  emergencyRelationController,
                  required: true,
                ),

                SizedBox(height: 24),

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
                    ),
                  ),

                SizedBox(height: 24),

                // Register Button
                ElevatedButton(
                  onPressed: isLoading ? null : _registerTourist,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Registering...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        )
                      : Text(
                          'REGISTER AS TOURIST',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),

                SizedBox(height: 16),

                // Back to Login
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Already have Tourist ID? Login instead'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool required = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return '$label is required';
                }
                return null;
              }
            : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}
