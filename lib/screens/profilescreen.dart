import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourist/models/usermodel.dart';
import 'package:smart_tourist/provider/userprovider.dart';
import 'package:smart_tourist/services/api_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final isEditable = userProvider.isProfileEditable;

    // Use controllers to manage text field state
    final nameController = TextEditingController(text: user.fullName);
    final touristIdController = TextEditingController(text: user.touristId);
    final nationalityController = TextEditingController(text: user.nationality);
    final ageController = TextEditingController(text: user.age);
    final genderController = TextEditingController(text: user.gender);
    final mobileController = TextEditingController(text: user.mobileNumber);
    final emailController = TextEditingController(text: user.email);
    final hotelController = TextEditingController(text: user.hotelAddress);
    final guideController = TextEditingController(text: user.localGuideContact);
    final emergencyNameController = TextEditingController(
      text: user.emergencyContactName,
    );
    final emergencyPhoneController = TextEditingController(
      text: user.emergencyContactPhone,
    );
    final emergencyRelationController = TextEditingController(
      text: user.emergencyContactRelation,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      appBar: AppBar(
        title: const Text(
          'PROFILE',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileRow([
                  _buildProfileField('Full Name', nameController, isEditable),
                ]),
                _buildProfileRow([
                  _buildProfileField(
                    'Tourist ID',
                    touristIdController,
                    false, // Tourist ID should not be editable
                  ),
                  _buildProfileField(
                    'Nationality',
                    nationalityController,
                    isEditable,
                  ),
                ]),
                _buildProfileRow([
                  _buildProfileField(
                    'Age',
                    ageController,
                    isEditable,
                    keyboardType: TextInputType.number,
                  ),
                  _buildProfileField('Gender', genderController, isEditable),
                ]),
                _buildProfileRow([
                  _buildProfileField(
                    'Mobile Number',
                    mobileController,
                    isEditable,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildProfileField(
                    'Email',
                    emailController,
                    false, // Email should not be editable after registration
                    keyboardType: TextInputType.emailAddress,
                  ),
                ]),
                _buildProfileRow([
                  _buildProfileField(
                    'Hotel/Stay address',
                    hotelController,
                    isEditable,
                  ),
                  _buildProfileField(
                    'Local guide contact',
                    guideController,
                    isEditable,
                  ),
                ]),

                const SizedBox(height: 20),
                const Text(
                  'Emergency Contact Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildProfileRow([
                  _buildProfileField(
                    'Name',
                    emergencyNameController,
                    isEditable,
                  ),
                ]),
                _buildProfileRow([
                  _buildProfileField(
                    'Phone Number',
                    emergencyPhoneController,
                    isEditable,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildProfileField(
                    'Relation',
                    emergencyRelationController,
                    isEditable,
                  ),
                ]),

                const SizedBox(height: 20),

                // Blockchain Status
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: user.blockchainStatus == 'ASSIGNED'
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: user.blockchainStatus == 'ASSIGNED'
                          ? Colors.green.shade200
                          : Colors.orange.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        user.blockchainStatus == 'ASSIGNED'
                            ? Icons.verified
                            : Icons.pending,
                        color: user.blockchainStatus == 'ASSIGNED'
                            ? Colors.green
                            : Colors.orange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Blockchain Status: ${user.blockchainStatus}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton('Save', Colors.green, () {
                      if (isEditable) {
                        // Save updated data to provider
                        userProvider.updateUser(
                          UserModel(
                            id: user.id,
                            fullName: nameController.text,
                            touristId: touristIdController.text,
                            nationality: nationalityController.text,
                            age: ageController.text,
                            gender: genderController.text,
                            mobileNumber: mobileController.text,
                            email: emailController.text,
                            hotelAddress: hotelController.text,
                            localGuideContact: guideController.text,
                            emergencyContactName: emergencyNameController.text,
                            emergencyContactPhone:
                                emergencyPhoneController.text,
                            emergencyContactRelation:
                                emergencyRelationController.text,
                            blockchainStatus: user.blockchainStatus,
                            isVerified: user.isVerified,
                            isActive: user.isActive,
                          ),
                        );
                        userProvider.setEditable(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profile Saved!')),
                        );
                      }
                    }, isEnabled: isEditable),
                    _buildActionButton('Edit', Colors.orange, () {
                      userProvider.setEditable(true);
                    }, isEnabled: !isEditable),
                    _buildActionButton('Logout', Colors.red, () async {
                      // Clear token and user data
                      await ApiService.clearToken();
                      userProvider.updateUser(UserModel());

                      // Navigate to login
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileRow(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: children
            .map(
              (c) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: children.indexOf(c) == 0 && children.length > 1
                        ? 16.0
                        : 0,
                  ),
                  child: c,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildProfileField(
    String label,
    TextEditingController controller,
    bool isEnabled, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: isEnabled ? Colors.white : Colors.grey[200],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String text,
    Color color,
    VoidCallback onPressed, {
    bool isEnabled = true,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      child: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: color.withOpacity(0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
