import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[

          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_screen_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'The Most Convenient Virtual Clinic',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No circling for parking, No long waits. No worries. Chat with a doctor online, anywhere, anytime.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to create account screen
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      ),
                      child: const Text('CREATE ACCOUNT'),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign-in screen
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: const Text('SIGN IN'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60), 
            ],
          ),
        ],
      ),
    );
  }
}
