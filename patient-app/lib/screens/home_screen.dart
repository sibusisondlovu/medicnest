import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/action_button_grid_widget.dart';
import '../widgets/health_tips_widget.dart';
import '../widgets/infertility_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String id = "homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    _checkProfileCompletion();
  
  }

  Future<void> _checkProfileCompletion() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final profileDoc = await FirebaseFirestore.instance
          .collection('patients')
          .doc(user.uid)
          .get();

      if (!profileDoc.exists) {
        _showProfileIncompleteDialog();
      } else {
        final profileData = profileDoc.data();
        if (profileData != null && _isProfileComplete(profileData)) {

        } else {
          _showProfileIncompleteDialog();
        }
      }
    }
  }

  bool _isProfileComplete(Map<String, dynamic> profileData) {
    return profileData.containsKey('name') &&
        profileData.containsKey('age') &&
        profileData['name'] != null &&
        profileData['age'] != null;
  }

  void _showProfileIncompleteDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Incomplete Profile',
      desc:
      'Fill in your details before consulting with our health practitioners.',
      btnOkText: 'Proceed',
      btnOkOnPress: () {
        Navigator.pushNamed(context, '/editProfile');
      },
    ).show();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello JOHN'),
        actions: const [
          Icon(Icons.help_outline),
        ],
      ),
      body: ListView(
        children: const [
          SearchBar(),
          ActionButtonsGrid(),
          InfertilityCard(),
          HealthTipsSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messenger'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
