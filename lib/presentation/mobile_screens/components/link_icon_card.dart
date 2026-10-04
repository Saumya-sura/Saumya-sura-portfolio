import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/color_provider.dart';

class LinkIconCard extends StatefulWidget {
  const LinkIconCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final VoidCallback onTap;
  final dynamic icon; // Can be IconData or Widget

  @override
  State<LinkIconCard> createState() => _LinkIconCardState();
}

class _LinkIconCardState extends State<LinkIconCard> {
  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final foregroundColor = themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: themeColor,
                child: widget.icon is IconData
                    ? Icon(
                        widget.icon as IconData,
                        size: 32,
                        color: foregroundColor,
                      )
                    : ClipOval(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          child: widget.icon as Widget,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

