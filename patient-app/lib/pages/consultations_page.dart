import 'package:flutter/material.dart';

class ConsultationsPage extends StatefulWidget {
  const ConsultationsPage({super.key});

  @override
  State<ConsultationsPage> createState() => _ConsultationsPageState();
}

class _ConsultationsPageState extends State<ConsultationsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset('assets/images/health-report.png', width: MediaQuery.of(context).size.width * 0.5,),
        const Text("You have no consultation history",),
        const Text(textAlign: TextAlign.center, 'Start consulting with our doctors and your \nhealth records wil be kept here.')
      ],
    );
  }
}
