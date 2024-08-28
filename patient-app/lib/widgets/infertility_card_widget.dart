import 'package:flutter/material.dart';

class InfertilityCard extends StatelessWidget {
  const InfertilityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ASK ABOUT INFERTILITY ISSUES', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('MESSAGE A SPECIALIST NOW'),
                Icon(Icons.arrow_forward, color: Theme.of(context).primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}