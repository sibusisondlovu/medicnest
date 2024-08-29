import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/widgets/busy_dialog.dart';
import 'package:patient_app/widgets/buttons.dart';

import '../data/regions_list_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String id = "editProfileScreen";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _emailAddressController = TextEditingController();
  final _areaController = TextEditingController();
  String? _selectedRegion;
  String? _selectedGender;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        _nameController.text = data['names'] ?? '';
        _areaController.text = data['area'] ?? '';
        _selectedGender = data['gender'];

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    regionsList.sort((a, b) => a.compareTo(b));

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: _isLoading
            ? const Center(child: LoadingScreen())
            :  _buildProfileForm());
  }

  Widget _buildProfileForm() {
    return ListView(
      children: [
        Center(
          child: Stack(
            children: [
              const CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/images/default-avatar.png'),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      // Handle profile photo change
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name and Surname', // Floating label
            hintText: 'Enter your name and surname', // Placeholder
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name and surname';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: _phoneNumberController,
          decoration: const InputDecoration(
            labelText: 'Contact Number', // Floating label
            hintText: 'Enter your contact number', // Placeholder
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your contact number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          keyboardType: TextInputType.number,
          controller: _idNumberController,
          decoration: const InputDecoration(
            labelText: 'ID Number', // Floating label
            hintText: 'Enter your ID number', // Placeholder
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your ID number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Region',
            border: OutlineInputBorder(),
          ),
          value: _selectedRegion,
          onChanged: (newValue) {
            setState(() {
              _selectedRegion = newValue;
            });
          },
          items: regionsList.map((region) {
            return DropdownMenuItem<String>(
              value: region,
              child: Text(region),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        CustomElevatedButton(text: "Save Changes", onPressed: () {})
      ],
    );
  }
}
