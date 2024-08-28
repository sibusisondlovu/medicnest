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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello JOHN'),
        backgroundColor: Colors.teal,
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
