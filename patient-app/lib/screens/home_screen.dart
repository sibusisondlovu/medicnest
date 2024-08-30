import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/config/theme.dart';

import '../widgets/action_button_grid_widget.dart';
import '../widgets/action_button_widget.dart';
import '../widgets/health_tips_widget.dart';
import '../widgets/infertility_card_widget.dart';
import '../widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String id = "homeScreen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late DocumentSnapshot profileDoc;
  @override
  void initState() {
    super.initState();
    _checkProfileCompletion();
  }

  Future<void> _checkProfileCompletion() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      profileDoc = await FirebaseFirestore.instance
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

  bool _isProfileComplete(dynamic profileData) {
    return profileData.containsKey('dob') &&
        profileData['names'] != null &&
        profileData['phone'] != null;
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
        Navigator.pushNamed(context, 'editProfileScreen');
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> data = profileDoc.data() as Map<String, dynamic>;
    String name = data['names'] as String;
    return Scaffold(

      body: Stack(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: ListView(
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text('Hello $name', style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.white
                ),),
                const SizedBox(
                  height: 30,
                ),
                const CustomSearchBar(),
                const SizedBox(
                  height: 20,
                ),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, 'medicalJourneyScreen', arguments: profileDoc);
                        },
                        child: ActionButton(icon: Icons.assignment, title: 'Medical Journey')),
                    GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, 'askQuestionScreen');
                        },
                        child: ActionButton(icon: Icons.favorite, title: 'Ask Health Question')),
                    ActionButton(icon: Icons.location_on, title: 'Find Doctor or Pharmacy'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const InfertilityCard(),
                const SizedBox(
                  height: 20,
                ),
                const HealthTipsSection(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.message), label: 'Messenger'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
