import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/screens/home_screen.dart';
import 'package:patient_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/strings.dart';
import 'config/theme.dart';
import 'screens/onboarding_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  static const String id = 'wrapper';

  @override
  State<Wrapper> createState() => _WrapperScreenState();
}

class _WrapperScreenState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppTheme.mainColor, strokeWidth: 2,)));
        } else if (snapshot.hasError) {
          // Handle any errors
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          final bool isFirstTime = snapshot.data!;
          final  isAuthenticated = FirebaseAuth.instance.currentUser;
          return isFirstTime ? const OnBoardingScreen() :
          isAuthenticated == null? const LoginScreen() : const HomeScreen();
        }
      },
    );
  }

  Future<bool> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
     return prefs.getBool('first_time') ?? true; // Default value is true if key doesn't exist
  }
}