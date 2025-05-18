// Added a SkillBar component for skills visualization
import 'package:flutter/material.dart';

class SkillBar extends StatelessWidget {
  final String skill;
  final double level;

  const SkillBar({
    required this.skill,
    required this.level,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            skill,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: level,
            backgroundColor: Colors.grey[300],
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}