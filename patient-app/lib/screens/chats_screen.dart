import 'package:flutter/material.dart';
import 'package:patient_app/data/health_practioners_list.dart';

import '../config/theme.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});
  static const String id = "chatsScreen";

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
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
            child: Column(
              children: [
                _buildHeaderSection(context),

              ],
            ),
            // Add any child widgets you want inside the container
          ),
          _noChatsWidget()
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column (
      children: [
        const SizedBox(height: 10,),
        const Text(
          textAlign: TextAlign.center,
          'CHATS',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.white),
        ),
        const SizedBox(height: 20,),
        const Text(
          textAlign: TextAlign.center,
          'FEATURED HEALTH PRACTITIONERS',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.white),
        ),
        _buildFeaturedHealthPractitionersSection(),
      ],
    );
  }

  Widget _buildFeaturedHealthPractitionersSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 150, // Adjust this value to change the height of the list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dummyHealthPractitioners.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildHealthPractitionerCard(dummyHealthPractitioners[index]),
          );
        },
      ),
    );
  }

  Widget _buildHealthPractitionerCard(practitioner) {
    return Container(
      width: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(practitioner.avatar),
          ),
          const SizedBox(height: 8),
          Text(
            practitioner.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            practitioner.speciality,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          if (practitioner.isFeatured)
            const Icon(Icons.star, color: Colors.yellow, size: 16),
        ],
      ),
    );
  }

  Widget _noChatsWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/health-report.png', width: MediaQuery.of(context).size.width * 0.5,),
        const Text("You have no chats history", style: TextStyle(
            fontSize: 13
        ),),
        const Text(textAlign: TextAlign.center, 'Start consulting with our doctors and your \nchats will be kept here.', style: TextStyle(
            fontSize: 13
        ),)
      ],
    );
  }
}
