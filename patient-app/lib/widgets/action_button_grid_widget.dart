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
        GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, 'medicalJourneyScreen');
            },
            child: ActionButton(icon: Icons.assignment, title: 'Medical Journey')),
        GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, 'askQuestionScreen');
            },
            child: ActionButton(icon: Icons.favorite, title: 'Ask Health Question')),
        ActionButton(icon: Icons.location_on, title: 'Find Doctor or Pharmacy'),
      ],
    );
  }
}