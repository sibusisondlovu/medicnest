import 'package:flutter/material.dart';

class PrescriptionsPage extends StatefulWidget {
  const PrescriptionsPage({super.key});

  @override
  State<PrescriptionsPage> createState() => _PrescriptionsPageState();
}

class _PrescriptionsPageState extends State<PrescriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset('assets/images/health-report.png', width: MediaQuery.of(context).size.width * 0.5,),
        const Text("You have no prescription records history", style: TextStyle(
          fontSize: 13
        ),),
        const SizedBox(height: 10,),
        const Text(textAlign: TextAlign.center, 'Start consulting with our doctors and your \nhealth records wil be kept here.', style: TextStyle(
    fontSize: 13))
      ],
    );
  }
}
