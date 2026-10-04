import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/color_provider.dart';

class SkillsChip extends StatefulWidget {
  const SkillsChip({super.key, required this.skillName, required this.icon});

  final String skillName;
  final dynamic icon; // Can be IconData or Widget

  @override
  State<SkillsChip> createState() => _SkillsChipState();
}

class _SkillsChipState extends State<SkillsChip> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Chip(
      side: BorderSide(
        color: Provider.of<ColorProvider>(context).color.withOpacity(0.5),
        width: 1,
      ),
      label: Text(
        widget.skillName,
        style: TextStyle(
          fontSize: 20,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      avatar: widget.icon is IconData
          ? Icon(
              widget.icon as IconData,
              color: iconColor,
            )
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: widget.icon as Widget,
            ),
    );
  }
}
