import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';
import 'components/experience_card.dart';
import 'devops_visualizer_page.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage>
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
          'Work Experience',
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
                // Header badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_rounded,
                        size: 16,
                        color: Colors.greenAccent.shade400,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "3 Software Engineering Internships",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                          fontFamily: GoogleFonts.rubik().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Experience Cards
                const ExperienceCard(
                  company: "Viscosity India",
                  role: "Tech Intern",
                  period: "May 2026 - Sep 2026",
                  location: "Mumbai, India",
                  icon: Icons.cloud_done_rounded,
                  bulletPoints: [
                    "Developed and deployed a new BODMAS Calculator feature, collaborating with the team to implement functionality and integrate it into the existing web application. Performed end-to-end website testing, identifying and validating bugs, ensuring feature quality.",
                    "Collaborated on maintaining a GitHub Actions CI/CD pipeline, enabling automated deployments and reducing manual effort by delivering code changes directly to the server.",
                  ],
                  technologies: [
                    "GitHub Actions",
                    "CI/CD Pipeline",
                    "Google Cloud",
                    "Web App",
                    "E2E Testing",
                  ],
                ),

                // CI/CD Pipeline Simulator Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2330),
                        foregroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.greenAccent.withOpacity(0.4),
                            width: 1.2,
                          ),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DevOpsVisualizerPage(initialTab: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_filled_rounded, size: 18),
                      label: const Text(
                        "Live CI/CD Pipeline Simulator ⚡",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                const ExperienceCard(
                  company: "Brown Bird Ventures",
                  role: "Flutter Intern",
                  period: "Nov 2024 - Jan 2025",
                  location: "Mumbai, India",
                  icon: Icons.pets_rounded,
                  bulletPoints: [
                    "Built a Flutter application featuring AI-powered pet care recommendations and chatbot assistance, integrating the ChatGPT API and GetX to support personalized user interactions during testing.",
                    "Designed an AI chatbot that generated pet-specific responses based on 5+ parameters (pet type, breed, age, weight, diet, etc.), improving recommendation accuracy and user relevance.",
                  ],
                  technologies: [
                    "Flutter",
                    "GetX",
                    "ChatGPT API",
                    "AI Chatbot",
                    "REST APIs",
                    "Mobile Architecture",
                  ],
                ),

                const ExperienceCard(
                  company: "Sayge Tech",
                  role: "Flutter Intern",
                  period: "May 2025 - July 2025",
                  location: "Mumbai, India",
                  icon: Icons.devices_rounded,
                  bulletPoints: [
                    "Managed development and maintenance of 3 Flutter mobile applications, contributing to 20+ feature enhancements, UI improvements, and critical bug resolutions.",
                    "Delivered client-specific customizations including branding updates, responsive layouts, and feature configuration across multiple projects, ensuring on-time project delivery.",
                  ],
                  technologies: [
                    "Flutter",
                    "Dart",
                    "Client Customization",
                    "Responsive UI",
                    "Bug Resolution",
                    "Production Apps",
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
