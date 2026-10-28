import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';

class LeadershipPage extends StatefulWidget {
  const LeadershipPage({super.key});

  @override
  State<LeadershipPage> createState() => _LeadershipPageState();
}

class _LeadershipPageState extends State<LeadershipPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Leadership & Research',
          style: TextStyle(
            color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeColor.withOpacity(0.8),
              themeColor.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Research Highlight Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF2E1A47).withOpacity(0.9),
                          const Color(0xFF1B2430).withOpacity(0.9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.amberAccent.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.amberAccent.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: Colors.amberAccent,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Springer Research Co-Author",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "FICTA 2025 International Conference",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.amberAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Co-authored academic research paper accepted for FICTA 2025 conference proceedings, published by Springer. Dedicated to cloud-native systems, DevOps automation, and computational engineering.",
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: Colors.white.withOpacity(0.9),
                            fontFamily: GoogleFonts.rubik().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // FinDrome - Managing Director
                _buildLeadershipCard(
                  context: context,
                  title: "FinDrome",
                  role: "Managing Director",
                  icon: Icons.campaign_rounded,
                  themeColor: themeColor,
                  isDark: isDark,
                  bullets: [
                    "Orchestrated large-scale college fests and flagship events, mobilizing and directing a 100+ student workforce while optimizing inter-departmental workflows to guarantee seamless, on-time execution.",
                    "Institutionalized operational frameworks across multiple departments, bridging communication gaps between technical, event, and logistical teams to elevate the overall quality of committee deliverables.",
                  ],
                  tags: ["Event Direction", "100+ Team Lead", "Workflow Optimization", "Executive Management"],
                ),

                // FinDrome - Tech Head
                _buildLeadershipCard(
                  context: context,
                  title: "FinDrome",
                  role: "Tech Head & Event Head",
                  icon: Icons.engineering_rounded,
                  themeColor: themeColor,
                  isDark: isDark,
                  bullets: [
                    "Directed the complete project lifecycle of technical initiatives from inception to deployment, translating broad organizational goals into strict development milestones.",
                    "Managed and mentored a 6-member engineering team, optimizing development efforts and overseeing implementation to consistently deliver high-quality solutions on time.",
                    "Also as an Event Head, successfully managed logistics, scheduling, and on-ground operations for 200+ attendees and maintained seamless cross-department communication and faculty coordination.",
                  ],
                  tags: ["Tech Mentorship", "6-Member Team Lead", "200+ Attendee Logistics", "End-to-End Delivery"],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadershipCard({
    required BuildContext context,
    required String title,
    required String role,
    required IconData icon,
    required Color themeColor,
    required bool isDark,
    required List<String> bullets,
    required List<String> tags,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: themeColor.withOpacity(0.4),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: themeColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: themeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                height: 1,
                color: isDark ? Colors.white12 : Colors.black12,
              ),
              const SizedBox(height: 12),
              for (var bullet in bullets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0, right: 8.0),
                        child: Container(
                          width: 6,
                          height: 6,
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
                            fontSize: 13,
                            height: 1.45,
                            color: isDark
                                ? Colors.white.withOpacity(0.88)
                                : Colors.black87,
                            fontFamily: GoogleFonts.rubik().fontFamily,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (var tag in tags)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                        tag,
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
    );
  }
}
