import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/color_provider.dart';

class AboutMe extends StatefulWidget {
  const AboutMe({
    super.key,
    this.isPopup = false,
  });

  final bool isPopup;

  @override
  State<AboutMe> createState() => _AboutMeState();
}

class _AboutMeState extends State<AboutMe> {
  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: !widget.isPopup
              ? MediaQuery.of(context).size.width * 0.22
              : MediaQuery.of(context).size.width * 0.5,
          minHeight: !widget.isPopup
              ? MediaQuery.of(context).size.height * 0.25
              : MediaQuery.of(context).size.height * 0.5,
          minWidth: !widget.isPopup
              ? MediaQuery.of(context).size.width * 0.2
              : MediaQuery.of(context).size.width * 0.5,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Hello, World! 👋",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Shimmer.fromColors(
                baseColor: isDark ? Colors.white : Colors.black,
                highlightColor: themeColor,
                period: const Duration(milliseconds: 2500),
                child: const Text(
                  "I am Saumya Sura",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: themeColor.withOpacity(0.35),
                    width: 1,
                  ),
                ),
                child: Text(
                  "Flutter • Springer Co-Author • Cloud & DevOps",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Computer Engineering student at MPSTME (NMIMS) with 3 software engineering internships spanning Flutter development and cloud infrastructure on Google Cloud. Springer research co-author (FICTA 2025) with a focus on DevOps, cloud-native systems, and infrastructure automation.",
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: isDark ? Colors.white.withOpacity(0.85) : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                children: [
                  _buildStatChip(context, "3 Internships", Icons.work_outline_rounded, themeColor),
                  _buildStatChip(context, "FICTA 2025", Icons.menu_book_rounded, themeColor),
                  _buildStatChip(context, "1,500+ Downloads", Icons.download_rounded, themeColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(0.3)
            : Colors.grey.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
