import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_tourist/provider/userprovider.dart';
import 'package:smart_tourist/widget/MapView.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the user's name from the provider
    final user = Provider.of<UserProvider>(context).user;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF0F4FF),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Row(
            children: [
              // const Icon(Icons.location_on, color: Color(0xFF0D47A1)),
              // const SizedBox(width: 8),
              const Text(
                'Tourist Safety Monitor',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const Spacer(),
              Text(
                user.fullName,
                style: const TextStyle(
                  color: Color(0xFF0D47A1),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
                child: const CircleAvatar(
                  child: Icon(Icons.person),
                  backgroundColor: Color(0xFF4A55E1),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              // Welcome Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Mapview(),
              ),
              const SizedBox(height: 30),
              // Personal Details Section
              const Text(
                'Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailChip('Age'),
                  _buildDetailChip('Blood Group'),
                  _buildDetailChip('Gender'),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: const Center(
                      child: Text(
                        'Photo',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildDetailButton('Medical History'),
              _buildDetailCard('Medical Conditions:', ''),
              _buildDetailCard('Medications:', ''),
              _buildDetailCard('Insurance Details:', ''),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SOS Signal Sent! Help is on the way.'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
            elevation: 8,
          ),
          child: const Text(
            'SOS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildDetailButton(String title) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(title, style: TextStyle(color: Colors.grey[800])),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        elevation: 2,
      ),
    );
  }

  Widget _buildDetailCard(String title, String content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              Text(
                content.isEmpty ? 'Not Provided' : content,
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
