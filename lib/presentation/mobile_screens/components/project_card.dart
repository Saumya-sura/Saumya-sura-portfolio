import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/color_provider.dart';

class ProjectCard extends StatefulWidget {
  const ProjectCard({
    super.key,
    required this.projectName,
    this.projectSubtitle,
    required this.projectDescription,
    required this.projectLink,
    required this.projectTechnologies,
    this.bulletPoints,
    this.icon,
    this.linkLabel,
  });

  final String projectName;
  final String? projectSubtitle;
  final String projectDescription;
  final String projectLink;
  final List<String> projectTechnologies;
  final List<String>? bulletPoints;
  final IconData? icon;
  final String? linkLabel;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: themeColor.withOpacity(0.35),
              width: 1.2,
            ),
          ),
          color: isDark ? const Color(0xFF1E1E26) : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              if (widget.projectLink.isNotEmpty) {
                launchUrl(
                  Uri.parse(widget.projectLink),
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Subtitle + Action link row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.icon != null) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: themeColor.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: themeColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.projectName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                                letterSpacing: -0.2,
                              ),
                            ),
                            if (widget.projectSubtitle != null) ...[
                              const SizedBox(height: 3),
                              Text(
                                widget.projectSubtitle!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: themeColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.projectLink.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.linkLabel ?? "Open",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: themeColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.open_in_new_rounded,
                                size: 12,
                                color: themeColor,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Project Description
                  Text(
                    widget.projectDescription,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.45,
                      color: isDark ? Colors.white.withOpacity(0.85) : Colors.black87,
                      fontFamily: GoogleFonts.rubik().fontFamily,
                    ),
                  ),

                  // Bullet Points (if any)
                  if (widget.bulletPoints != null && widget.bulletPoints!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    for (var bullet in widget.bulletPoints!)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0, right: 8.0),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: themeColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                bullet,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  height: 1.4,
                                  color: isDark
                                      ? Colors.white.withOpacity(0.78)
                                      : Colors.black87,
                                  fontFamily: GoogleFonts.rubik().fontFamily,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],

                  const SizedBox(height: 12),

                  // Technology Tags
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (var technology in widget.projectTechnologies)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: themeColor.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            technology,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                    ],
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
