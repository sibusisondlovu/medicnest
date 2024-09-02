import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const String id = "profileScreen";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Container(
        height:
            MediaQuery.of(context).size.height * 0.4, // 40% of screen height
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: ListView(
          children: [
            Image.asset(
              'assets/images/default-avatar.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'Sibusiso',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.all(
                10,
              ),
              width: MediaQuery.of(context).size.width,
              color: AppTheme.mainColor,
              child: const Column(
                children: [
                  Icon(
                    Icons.monitor_heart_outlined,
                    size: 90,
                    color: Colors.white,
                  ),
                  Text(
                    "Medical Journey",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    "View your medical notes, prescriptions and more",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  )
                ],
              ),
            ),
            Card(
              child: ListTile(
                onTap: (){
                  Navigator.pushReplacementNamed(context, 'editProfileScreen');
                },
                leading: const Icon(Icons.person),
                title: const Text('Edit Profile', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),),
                subtitle: const Text('Update your profile on MedicNest', style: TextStyle(
                  fontSize: 12
                ),),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.credit_card),
                title: Text('Payment History', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),),
                subtitle: Text('View your transaction on MedicNest', style: TextStyle(
                    fontSize: 12
                ),),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
            const Card(
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Change Password', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                ),),
                subtitle: Text('Change your existing password', style: TextStyle(
                    fontSize: 12
                ),),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            )
          ],
        ),
      ),

    ]));
  }
}
