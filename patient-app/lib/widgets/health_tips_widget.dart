import 'package:flutter/material.dart';

import 'health_tip_card_widget.dart';

class HealthTipsSection extends StatelessWidget {
  const HealthTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Health Tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {},
              child: Text('View More', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              HealthTipCard(
                title: 'Helicobacter Pylori infection of the stomach',
                imageUrl: 'https://example.com/image1.jpg',
              ),
              HealthTipCard(
                title: 'Proton pump inhib Gastric symptoms',
                imageUrl: 'https://example.com/image2.jpg',
              ),
            ],
          ),
        ),
      ],
    );
  }
}