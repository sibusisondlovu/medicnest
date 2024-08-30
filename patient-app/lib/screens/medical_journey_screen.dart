import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:patient_app/config/theme.dart';
import 'package:patient_app/pages/consultations_page.dart';
import 'package:patient_app/pages/notes_page.dart';

import '../pages/prescriptions_page.dart';

class MedicalJourneyScreen extends StatefulWidget {
  MedicalJourneyScreen({super.key, required this.data});
  static const String id = "medicalJourneyScreen";
  DocumentSnapshot data;

  @override
  State<MedicalJourneyScreen> createState() => _MedicalJourneyScreenState();
}

class _MedicalJourneyScreenState extends State<MedicalJourneyScreen>
    with SingleTickerProviderStateMixin {
  // Add this mixin
  late TabController _tabController; // Declare TabController
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this); // Initialize TabController
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose TabController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
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
                        'MEDICAL HISTORY',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListTile(
                      leading: CircleAvatar(
                          radius: 20,
                          child: Image.asset(
                              fit: BoxFit.contain,
                              'assets/images/default-avatar.png')),
                      title: Text(
                        widget.data['names'],
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                      subtitle: Text(
                        widget.data['id'],
                        style: const TextStyle(fontSize: 13),
                      ),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Card(
                  child: TabBar(
                    labelStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.bold),
                    controller:
                        _tabController, // Assign TabController to TabBar
                    tabs: const [
                      Tab(
                        icon: Icon(Icons.note),
                        text: "Prescription",
                      ),
                      Tab(
                        icon: Icon(Icons.person),
                        text: "Notes",
                      ),
                      Tab(
                        icon: Icon(Icons.share),
                        text: "Consultations",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Card(
                    child: TabBarView(
                      controller:
                          _tabController, // Assign TabController to TabBarView
                      children: const [
                        PrescriptionsPage(),
                        NotesPage(),
                        ConsultationsPage()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
