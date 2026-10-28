import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';
import 'components/divider_with_text.dart';
import 'components/hobby_card.dart';
import 'components/resume_modal.dart';
import 'components/timeline_item.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'About Me',
          style: TextStyle(
            color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_rounded),
            tooltip: "Open PDF Resume",
            onPressed: () => ResumeModal.show(context),
          ),
        ],
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeColor.withOpacity(0.5),
              themeColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  // Avatar stack with glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: themeColor,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeColor.withOpacity(0.4),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 70,
                          backgroundImage: AssetImage('assets/my.jpeg'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Pulsing Availability Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const PulsingStatusWidget(),
                  ),
                  const SizedBox(height: 12),

                  Text(
                    'Saumya Sura',
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 32 : 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Flutter Developer • Springer Research Co-Author • Cloud & DevOps Enthusiast',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 15 : 13,
                      fontWeight: FontWeight.w600,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mukesh Patel School of Technology Management and Engineering, Mumbai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 14 : 12,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Professional Summary Card (From Resume)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E26) : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: themeColor.withOpacity(0.35),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.notes_rounded, size: 18, color: themeColor),
                            const SizedBox(width: 8),
                            Text(
                              "Executive Summary",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Computer Engineering student with three software engineering internships spanning Flutter development and cloud infrastructure. Experienced in building mobile applications, automating deployment workflows, and deploying applications on Google Cloud. Springer research co-author (FICTA 2025) with a growing focus on DevOps, cloud-native systems, and infrastructure automation.",
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.5,
                            color: isDark ? Colors.white.withOpacity(0.88) : Colors.black87,
                            fontFamily: GoogleFonts.rubik().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Embedded PDF Resume Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => ResumeModal.show(context),
                      icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
                      label: const Text(
                        "Open PDF Resume Viewer 📄",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // Hobbies & Interests Section
                  const DividerWithText(text: "Core Interests"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      HobbyCard(
                        title: "Flutter & Mobile",
                        icon: Icons.phone_android_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "Cloud & DevOps",
                        icon: Icons.cloud_done_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "CI/CD Automation",
                        icon: Icons.sync_alt_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "Springer Research",
                        icon: Icons.science_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "AI & Chatbots",
                        icon: Icons.smart_toy_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "Chess",
                        icon: Icons.grid_on_rounded,
                        color: themeColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Timeline / Career Journey Section (100% Complete from Resume)
                  const DividerWithText(text: "Career Journey"),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      // 1. SSC Rustomjee
                      TimelineItem(
                        title: "Secondary School Certificate (SSC)",
                        subtitle: "Completed foundational secondary schooling at Rustomjee International School, Mumbai.",
                        date: "2022",
                        icon: Icons.school_outlined,
                        color: themeColor,
                        tags: const ["SSC Completed", "Rustomjee International", "Mumbai"],
                      ),

                      // 2. B.Tech Computer Engineering
                      TimelineItem(
                        title: "B.Tech in Computer Engineering",
                        subtitle: "Joined NMIMS MPSTME, Mumbai for B.Tech in Computer Engineering. Specializing in mobile apps, cloud systems, and DevOps.",
                        date: "2022 - 2028",
                        icon: Icons.school_rounded,
                        color: themeColor,
                        tags: const ["B.Tech", "Computer Engineering", "NMIMS MPSTME"],
                      ),

                      // 3. MPSTME OnTrack Launch
                      TimelineItem(
                        title: "MPSTME OnTrack Launch",
                        subtitle: "Built an offline-first campus navigation & timetable alert system for university students.",
                        date: "2023 - 2024",
                        icon: Icons.rocket_launch_rounded,
                        color: themeColor,
                        bulletPoints: const [
                          "Over-the-air (OTA) timetable and map updates",
                          "1,500+ downloads on Google Play Store & Apple App Store",
                        ],
                        tags: const ["Flutter", "Offline-First", "App Store", "Play Store"],
                      ),

                      // 4. FinDrome Leadership
                      TimelineItem(
                        title: "FinDrome (Managing Director & Tech Head)",
                        subtitle: "Orchestrated large-scale flagship fests, directing 100+ student workforce and managing technical project delivery.",
                        date: "2023 - 2024",
                        icon: Icons.groups_rounded,
                        color: themeColor,
                        bulletPoints: const [
                          "Directed 100+ student team and built inter-departmental workflows",
                          "Managed 6-member engineering team & on-ground ops for 200+ attendees",
                        ],
                        tags: const ["Managing Director", "Tech Head", "100+ Team", "Operations"],
                      ),

                      // 5. Brown Bird Ventures
                      TimelineItem(
                        title: "Flutter Intern @ Brown Bird Ventures",
                        subtitle: "Built AI-powered pet care recommendations & chatbot assistance using ChatGPT API and GetX.",
                        date: "Nov 2024 - Jan 2025",
                        icon: Icons.pets_rounded,
                        color: themeColor,
                        bulletPoints: const [
                          "Engineered AI chatbot evaluating 5+ pet parameters (breed, age, diet)",
                          "Integrated GetX state management and personalized user testing flows",
                        ],
                        tags: const ["Flutter", "ChatGPT API", "GetX", "AI Chatbot", "Mumbai"],
                      ),

                      // 6. Sayge Tech
                      TimelineItem(
                        title: "Flutter Intern @ Sayge Tech",
                        subtitle: "Managed development and maintenance of 3 Flutter mobile applications.",
                        date: "May 2025 - Jul 2025",
                        icon: Icons.devices_rounded,
                        color: themeColor,
                        bulletPoints: const [
                          "Contributed to 20+ feature enhancements, UI polish, and critical bug fixes",
                          "Shipped client branding, responsive layouts, and cross-platform builds",
                        ],
                        tags: const ["Flutter", "Dart", "3 Production Apps", "Client Delivery"],
                      ),

                      // 7. Springer Research Co-Author
                      TimelineItem(
                        title: "Springer Research Co-Author (FICTA 2025)",
                        subtitle: "Co-authored academic research paper accepted for FICTA 2025 conference proceedings, published by Springer.",
                        date: "2025",
                        icon: Icons.workspace_premium_rounded,
                        color: themeColor,
                        bulletPoints: const [
                          "Research focused on cloud-native systems, automation, & computing",
                          "Published in prestigious Springer conference series",
                        ],
                        tags: const ["Springer Nature", "FICTA 2025", "Research Co-Author"],
                      ),

                      // 8. Viscosity India
                      TimelineItem(
                        title: "Tech Intern @ Viscosity India",
                        subtitle: "Developed & deployed new BODMAS Calculator web feature and managed automated deployment pipelines.",
                        date: "May 2026 - Sep 2026",
                        icon: Icons.cloud_done_rounded,
                        color: themeColor,
                        bulletPoints: const [
                          "Integrated calculator functionality and conducted end-to-end web testing",
                          "Maintained automated GitHub Actions CI/CD pipelines delivering to server",
                        ],
                        tags: const ["GitHub Actions", "CI/CD", "Google Cloud", "Web App Testing"],
                      ),

                      // 9. Expected Graduation
                      TimelineItem(
                        title: "Expected Graduation (B.Tech)",
                        subtitle: "Completing B.Tech in Computer Engineering degree at NMIMS MPSTME, Mumbai.",
                        date: "2028",
                        icon: Icons.flag_rounded,
                        isLast: true,
                        color: themeColor,
                        tags: const ["Class of 2028", "Computer Engineering"],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PulsingStatusWidget extends StatefulWidget {
  const PulsingStatusWidget({super.key});

  @override
  State<PulsingStatusWidget> createState() => _PulsingStatusWidgetState();
}

class _PulsingStatusWidgetState extends State<PulsingStatusWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.greenAccent.shade400,
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.shade400.withOpacity(0.6),
                    blurRadius: 10 * _pulseAnimation.value,
                    spreadRadius: 4 * _pulseAnimation.value,
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        Text(
          "Available for Opportunities",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.9)
                : Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
