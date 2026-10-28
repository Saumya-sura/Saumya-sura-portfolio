import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';
import 'components/project_card.dart';
import 'devops_visualizer_page.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  String _selectedCategory = "All";

  final List<Map<String, dynamic>> _filterChips = [
    {"label": "All", "count": 5, "icon": Icons.apps_rounded},
    {"label": "Cloud & DevOps", "count": 1, "icon": Icons.cloud_done_rounded},
    {"label": "Flutter & Mobile", "count": 4, "icon": Icons.phone_android_rounded},
    {"label": "AI & Chatbots", "count": 1, "icon": Icons.smart_toy_rounded},
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final showCloud = _selectedCategory == "All" || _selectedCategory == "Cloud & DevOps";
    final showFindly = _selectedCategory == "All" || _selectedCategory == "Flutter & Mobile";
    final showOnTrack = _selectedCategory == "All" || _selectedCategory == "Flutter & Mobile";
    final showPetCare = _selectedCategory == "All" ||
        _selectedCategory == "Flutter & Mobile" ||
        _selectedCategory == "AI & Chatbots";
    final showWellVerse = _selectedCategory == "All" || _selectedCategory == "Flutter & Mobile";

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Projects',
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
          child: Column(
            children: [
              // Category Filter Bar
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterChips.length,
                  itemBuilder: (context, index) {
                    final chip = _filterChips[index];
                    final String label = chip["label"];
                    final int count = chip["count"];
                    final IconData icon = chip["icon"];
                    final isSelected = _selectedCategory == label;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = label;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? themeColor
                                : (isDark ? const Color(0xFF1B2330) : Colors.white),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? themeColor
                                  : (isDark ? Colors.white12 : Colors.black12),
                              width: 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: themeColor.withOpacity(0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                icon,
                                size: 14,
                                color: isSelected
                                    ? (themeColor.computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white)
                                    : (isDark ? Colors.white70 : Colors.black87),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? (themeColor.computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white)
                                      : (isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.black.withOpacity(0.2)
                                      : (isDark
                                          ? Colors.white.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.2)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "$count",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? (themeColor.computeLuminance() > 0.5
                                            ? Colors.black
                                            : Colors.white)
                                        : (isDark ? Colors.white70 : Colors.black87),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              // 1. Scalable Web Infrastructure on GCP
              if (showCloud) ...[
                const ProjectCard(
                  projectName: 'Scalable Web Infrastructure on GCP',
                  projectSubtitle: 'Cloud Infrastructure & Application Deployment',
                  projectDescription:
                      'Engineered and automated a resilient, highly available web hosting architecture on Google Cloud Platform with complete infrastructure provisioning.',
                  icon: Icons.cloud_circle_rounded,
                  projectLink: 'https://github.com/Saumya-sura/gke-cicd',
                  linkLabel: 'GitHub',
                  bulletPoints: [
                    'Designed a scalable web hosting infrastructure on Google Cloud Platform (GCP) using Compute Engine, Managed Instance Groups, HTTP(S) Load Balancer, and Cloud Storage.',
                    'Configured secure networking with Google-managed SSL certificates, Identity and Access Management (IAM), VPC firewall rules, Cloud DNS, and automatic HTTP-to-HTTPS redirection.',
                    'Automated application deployment and infrastructure management using Cloud Shell, SSH, Nginx, and the gcloud CLI, streamlining deployment workflows and server provisioning.',
                  ],
                  projectTechnologies: [
                    'Google Cloud (GCP)',
                    'Compute Engine',
                    'Managed Instance Groups',
                    'Load Balancer',
                    'Cloud Storage',
                    'Nginx',
                    'IAM & VPC',
                    'Cloud DNS',
                    'gcloud CLI',
                  ],
                ),

                // Interactive Architecture Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2330),
                        foregroundColor: Colors.cyanAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.cyanAccent.withOpacity(0.4),
                            width: 1.2,
                          ),
                        ),
                        elevation: 2,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DevOpsVisualizerPage(initialTab: 0),
                          ),
                        );
                      },
                      icon: const Icon(Icons.hub_rounded, size: 18),
                      label: const Text(
                        "Interactive GCP Architecture Diagram 🌐",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // 2. FindLy
              if (showFindly)
                const ProjectCard(
                  projectName: 'FindLy',
                  projectSubtitle: 'Real-Time Lost And Found System',
                  projectDescription:
                      'A Flutter & Supabase powered intelligent lost-and-found mobile ecosystem with instant notification syncing and smart item matching.',
                  icon: Icons.search_rounded,
                  projectLink: 'https://github.com/Saumya-sura/dhundo',
                  linkLabel: 'GitHub',
                  bulletPoints: [
                    'Developed FindLy, a Flutter-based lost & found platform integrated with Supabase, implementing secure authentication, cloud storage, real-time database synchronization, and intelligent item matching using metadata-based filtering.',
                    'Implemented offline data persistence, retry synchronization, privacy-focused contact sharing, and end-to-end status tracking, enhancing application reliability and scalability.',
                  ],
                  projectTechnologies: [
                    'Flutter',
                    'Supabase',
                    'Dart',
                    'Real-Time DB',
                    'Metadata Filtering',
                    'Offline Sync',
                  ],
                ),

              // 3. MPSTME OnTrack
              if (showOnTrack)
                const ProjectCard(
                  projectName: 'MPSTME OnTrack',
                  projectSubtitle: 'Campus Navigation and Alert Platform',
                  projectDescription:
                      'Built a campus navigation and schedule alert system for MPSTME students to navigate easily and never miss a class.',
                  icon: Icons.map_rounded,
                  projectLink: 'https://github.com/AppDev-GDSC-MPSTME/MPSTME_OnTrack',
                  linkLabel: 'GitHub',
                  bulletPoints: [
                    'Built a campus navigation system for MPSTME students to navigate easily through the university.',
                    'Offline First Application, with over-the-air map updates and advertisement delivery for upcoming university events and important announcements.',
                    'Developed using Flutter and deployed on Android and iOS with 1,500+ downloads.',
                  ],
                  projectTechnologies: [
                    'Flutter',
                    'Android',
                    'iOS',
                    'Offline-First',
                    'OTA Updates',
                    '1,500+ Downloads',
                  ],
                ),

              // 4. Brown Bird Pet Care AI (TOT App)
              if (showPetCare)
                const ProjectCard(
                  projectName: 'Brown Bird Pet Care AI',
                  projectSubtitle: 'AI-Powered Pet Care & Recommendations',
                  projectDescription:
                      'An intelligent pet wellness assistant offering customized care recommendations, health logging, and conversational AI assistance.',
                  icon: Icons.pets_rounded,
                  projectLink: 'https://github.com/Saumya-sura',
                  linkLabel: 'Internship',
                  bulletPoints: [
                    'Built a Flutter application featuring AI-powered pet care recommendations and chatbot assistance, integrating the ChatGPT API and GetX to support personalized user interactions during testing.',
                    'Designed an AI chatbot that generated pet-specific responses based on 5+ parameters (pet type, breed, age, weight, diet, etc.), improving recommendation accuracy and user relevance.',
                  ],
                  projectTechnologies: [
                    'Flutter',
                    'GetX',
                    'ChatGPT API',
                    'Firebase',
                    'Hive',
                    'Google Play Store',
                  ],
                ),

              // 5. WellVerse
              if (showWellVerse)
                const ProjectCard(
                  projectName: 'WellVerse',
                  projectSubtitle: 'Mantra Meditation & Focus App',
                  projectDescription:
                      'A soothing offline mantra meditation app designed for mental peace and mindfulness with local SQLite caching.',
                  icon: Icons.self_improvement_rounded,
                  projectLink: 'https://github.com/Saumya-sura',
                  linkLabel: 'GitHub',
                  projectTechnologies: [
                    'Flutter',
                    'SQLite',
                    'Audio Engine',
                    'Local DB',
                  ],
                ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}