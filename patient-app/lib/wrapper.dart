import 'package:flutter/material.dart';

import 'config/strings.dart';
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
          return const Scaffold(body: Center(child: CircularProgressIndicator(color: Strings.mainColor, strokeWidth: 2,)));
        } else if (snapshot.hasError) {
          // Handle any errors
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          final bool isFirstTime = snapshot.data!;
          return isFirstTime ? const OnBoardingScreen() : const OnBoardingScreen();
        }
      },
    );
  }

  Future<bool> checkFirstTime() async {
    return true;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getBool('first_time') ?? true; // Default value is true if key doesn't exist
  }
}