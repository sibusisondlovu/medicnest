import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:patient_app/data/genders_list.dart';
import 'package:patient_app/widgets/busy_dialog.dart';
import 'package:patient_app/widgets/buttons.dart';

import '../config/theme.dart';
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
  final _areaController = TextEditingController();
  String? _selectedRegion;
  String? _selectedGender;
  bool _isLoading = true;
  bool _isSaving = false;

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
        _idNumberController.text = data['id'];
        _phoneNumberController.text = data['phone'];
        _selectedGender = data['gender'];
        _selectedRegion = data['area'];

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
        body: _isLoading
            ? const Center(child: LoadingScreen())
            :  Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height *
                0.35, // 40% of screen height
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.mainColor,
                  AppTheme.ascentColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            // Add any child widgets you want inside the container
          ),
              Container(
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                  padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white),
                          ),
                          const Expanded(
                            child: Text(
                              textAlign: TextAlign.center,
                              'EDIT PROFILE',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 60),
                          child: Card(child: Padding(

                            padding: const EdgeInsets.all(10.0),
                            child: _buildProfileForm(),
                          )),
                        ),
                      ),
                    ],
                  ))]));
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
                  backgroundColor: AppTheme.mainColor,
                  child: IconButton(
                    icon: const Icon(Icons.camera_alt, color: Colors.white),
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
            labelText: 'Gender',
            border: OutlineInputBorder(),
          ),
          value: _selectedGender,
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
          items: genderList.map((gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
        ),

        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Area',
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

        _isSaving? const Column(
          children: [
            SpinKitFadingFour(
              color: AppTheme.mainColor,
              size: 50,
            ),
            SizedBox(height: 20,),
            Text('Updating. Please wait...')
          ],
        ) : CustomElevatedButton(text: "Save Changes", onPressed: () async {
          setState(() {
            _isSaving = true;
          });

          try {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance.collection('patients').doc(user.uid).update({
                'names': _nameController.text.trim(),
                'phone': _phoneNumberController.text.trim(), // Assuming age is an integer
                'id': _idNumberController.text.trim(),
                'gender':_selectedGender,
                'area':_selectedRegion
              });

              // Show a success message (optional)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data saved successfully!')),
              );
            }
          } catch (e) {
            // Handle errors
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('An error occurred. Please try again.')),
            );
          } finally {
            setState(() {
              _isSaving = false;
            });
          }
        })
      ],
    );
  }
}
