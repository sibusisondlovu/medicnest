import 'package:flutter/material.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Image.asset('assets/images/health-report.png', width: MediaQuery.of(context).size.width * 0.5,),
        const Text("You have no notes history",),
        const Text(textAlign: TextAlign.center, 'Start consulting with our doctors and your \nhealth records wil be kept here.')
      ],
    );
  }
}
