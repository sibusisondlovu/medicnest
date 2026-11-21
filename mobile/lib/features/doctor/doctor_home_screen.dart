import 'package:flutter/material.dart';

import '../../shared/feature_list_scaffold.dart';
import '../../shared/upcoming_feature_card.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeatureListScaffold(
      title: 'Practitioner',
      intro: 'Write as you always do. Medicnest turns it into a record you '
          'approve.',
      children: [
        UpcomingFeatureCard(
          icon: Icons.draw_outlined,
          title: 'Handwritten consultation note',
          description: 'Write with a stylus on your tablet, or type. Review '
              'the typed version beside your handwriting, fix anything '
              'flagged, then approve.',
        ),
        UpcomingFeatureCard(
          icon: Icons.description_outlined,
          title: 'Referral letter and prescription draft',
          description: 'Generated from your approved note as a PDF on your '
              'letterhead. Prescriptions need your handwritten signature.',
        ),
      ],
    );
  }
}
