import 'package:flutter/material.dart';
import 'package:patient_app/config/theme.dart';
import 'package:patient_app/pages/consultations_page.dart';
import 'package:patient_app/pages/notes_page.dart';

import '../pages/prescriptions_page.dart';

class MedicalJourneyScreen extends StatefulWidget {
  const MedicalJourneyScreen({super.key});
  static const String id = "medicalJourneyScreen";

  @override
  State<MedicalJourneyScreen> createState() => _MedicalJourneyScreenState();
}

class _MedicalJourneyScreenState extends State<MedicalJourneyScreen>
    with SingleTickerProviderStateMixin { // Add this mixin
  late TabController _tabController; // Declare TabController
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Initialize TabController
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Patient Details' ,),
      ),
      body: Column(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListTile(
                leading: CircleAvatar(
                    radius: 20,
                    child: Image.asset(
                        fit: BoxFit.contain,
                        'assets/images/default-avatar.png')),
                title: const Text('Ted M Moshwana'),
                subtitle: const Text('1012170978080'),
                trailing: TextButton(
                  onPressed: () {  },
                  child: const Text('Update'),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          TabBar(
            controller: _tabController, // Assign TabController to TabBar
            tabs: const [
              Tab(icon: Icon(Icons.note), text: "Prescription",),
              Tab(icon: Icon(Icons.person), text: "Notes",),
              Tab(icon: Icon(Icons.share), text: "Consultations",),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController, // Assign TabController to TabBarView
              children: const [
                PrescriptionsPage(),
                NotesPage(),
                ConsultationsPage()
              ],
            ),
          ),
        ],
      ),
    );
  }
}