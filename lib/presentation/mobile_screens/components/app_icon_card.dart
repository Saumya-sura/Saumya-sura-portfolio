import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/color_provider.dart';

class AppIconCard extends StatefulWidget {
  const AppIconCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Widget onTap;
  final IconData icon;

  @override
  State<AppIconCard> createState() => _AppIconCardState();
}

class _AppIconCardState extends State<AppIconCard> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: OpenContainer(
        transitionDuration: const Duration(milliseconds: 400),
        closedColor: Colors.transparent,
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, openContainer) {
          return Column(
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
                  backgroundColor: context.watch<ColorProvider>().color,
                  child: Icon(
                    widget.icon,
                    size: 34,
                    color:
                        context.read<ColorProvider>().color.computeLuminance() >
                                0.5
                            ? Colors.black
                            : Colors.white,
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
                  color:
                      context.read<ColorProvider>().color.computeLuminance() >
                              0.5
                          ? Colors.black
                          : Colors.white,
                ),
              ),
            ],
          );
        },
        openBuilder: (context, closeContainer) {
          return widget.onTap;
        },
      ),
    );
  }
}
