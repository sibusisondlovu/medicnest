import 'package:flutter/material.dart';

class HealthTipCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  const HealthTipCard({super.key, required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(imageUrl, width: MediaQuery.of(context).size.width,  height: 150, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(
            fontWeight: FontWeight.bold
          ),),
        ],
      ),
    );
  }
}