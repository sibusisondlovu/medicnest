import 'package:flutter/material.dart';

import 'action_button_widget.dart';

class ActionButtonsGrid extends StatelessWidget {
  const ActionButtonsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ActionButton(icon: Icons.assignment, title: 'Medical Journey'),
        ActionButton(icon: Icons.favorite, title: 'Ask Health Question'),
        ActionButton(icon: Icons.group, title: 'Invite Your Friends'),
        ActionButton(icon: Icons.local_pharmacy, title: 'Your Pharmacy Order'),
        ActionButton(icon: Icons.location_on, title: 'Find Pharmacy'),
      ],
    );
  }
}