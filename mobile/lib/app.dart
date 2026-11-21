import 'package:flutter/material.dart';

import 'features/start/role_select_screen.dart';
import 'shared/theme.dart';

class MedicnestApp extends StatelessWidget {
  const MedicnestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicnest',
      debugShowCheckedModeBanner: false,
      theme: buildMedicnestTheme(),
      home: const RoleSelectScreen(),
    );
  }
}
