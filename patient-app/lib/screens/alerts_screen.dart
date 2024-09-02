import 'package:flutter/material.dart';

import '../config/theme.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  static const String id = "alertsScreen";

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            height: 70,
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
            child: const Center(child: Text('ALERTS', style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.white))),
            // Add any child widgets you want inside the container
          ),
          _noAlertsWidget()
        ],
      ),
    );
  }

  Widget _noAlertsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset('assets/images/health-report.png', width: MediaQuery.of(context).size.width * 0.5,),
        const Text("You have no alerts", style: TextStyle(
            fontSize: 13
        ),),

      ],
    );
  }
}
