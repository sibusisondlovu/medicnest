import 'package:flutter/material.dart';

import '../doctor/doctor_home_screen.dart';
import '../patient/patient_home_screen.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.local_hospital_outlined,
                      size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('Medicnest',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Your health information, connected.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 48),
                  FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const DoctorHomeScreen()),
                    ),
                    child: const Text("I'm a health practitioner"),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const PatientHomeScreen()),
                    ),
                    child: const Text("I'm a patient"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
