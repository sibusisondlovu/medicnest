import 'package:flutter/material.dart';

import '../../shared/feature_list_scaffold.dart';
import '../../shared/upcoming_feature_card.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureListScaffold(
      title: 'Patient',
      intro: 'Understand your medicines, check how urgent it is, and find a '
          'GP near you.',
      children: [
        UpcomingFeatureCard(
          icon: Icons.document_scanner_outlined,
          title: 'Scan a prescription',
          description: 'Take a photo of your script to see each medicine and '
              'how to take it. Always confirm with your pharmacist or doctor.',
        ),
        UpcomingFeatureCard(
          icon: Icons.medication_outlined,
          title: 'My medicines',
          description: 'Keep a list of the medicines you take.',
        ),
        UpcomingFeatureCard(
          icon: Icons.health_and_safety_outlined,
          title: 'Health Assistant',
          description: 'Tell us how you feel and check how urgent it is. '
              'This is not a diagnosis.',
        ),
        UpcomingFeatureCard(
          icon: Icons.location_on_outlined,
          title: 'Find a GP',
          description: 'See GPs near you, with distance, opening hours, call '
              'and directions.',
        ),
      ],
    );
  }
}
