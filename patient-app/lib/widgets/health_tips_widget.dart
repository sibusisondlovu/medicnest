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
              Card(
                child: HealthTipCard(
                  title: 'Health Tip One Here',
                  imageUrl: 'assets/images/ob1.jpeg',
                ),
              ),
              Card(
                child: HealthTipCard(
                  title: 'Health Tip Two Here',
                  imageUrl: 'assets/images/ob2.jpeg',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}