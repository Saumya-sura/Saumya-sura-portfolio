import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../providers/color_provider.dart';

class ResumeModal extends StatefulWidget {
  const ResumeModal({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const ResumeModal(),
    );
  }

  @override
  State<ResumeModal> createState() => _ResumeModalState();
}

class _ResumeModalState extends State<ResumeModal> {
  int _activePage = 0; // 0: Page 1, 1: Page 2, 2: Full Document

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 820,
          maxHeight: size.height * 0.92,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131A22) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 25,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(
              color: themeColor.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // PDF Viewer Top Toolbar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1B2432) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? Colors.white10 : Colors.black12,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Saumya_Sura_Resume.pdf",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Flutter Developer • Cloud & DevOps • FICTA 2025 Co-Author",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Page Navigator Segmented Control
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F141C) : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPageButton(0, "Page 1", themeColor),
                          _buildPageButton(1, "Page 2", themeColor),
                          _buildPageButton(2, "Full", themeColor),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Download / GitHub Action Button
                    Tooltip(
                      message: "Download / Open Resume",
                      child: IconButton(
                        icon: const Icon(Icons.download_rounded, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: themeColor.withOpacity(0.15),
                          foregroundColor: themeColor,
                        ),
                        onPressed: () {
                          launchUrl(
                            Uri.parse("https://github.com/Saumya-sura"),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Close Button
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              // PDF Scrollable Document Canvas
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Center(
                    child: Column(
                      children: [
                        if (_activePage == 0 || _activePage == 2) ...[
                          _buildPage1Card(themeColor),
                          if (_activePage == 2) const SizedBox(height: 20),
                        ],
                        if (_activePage == 1 || _activePage == 2) ...[
                          _buildPage2Card(themeColor),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageButton(int pageIndex, String label, Color themeColor) {
    final isSelected = _activePage == pageIndex;
    return GestureDetector(
      onTap: () => setState(() => _activePage = pageIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? themeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? (themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white)
                : Colors.grey,
          ),
        ),
      ),
    );
  }

  // --- PAGE 1: HEADER, SUMMARY, EXPERIENCE, PROJECTS, LEADERSHIP ---
  Widget _buildPage1Card(Color themeColor) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Center(
            child: Column(
              children: [
                Text(
                  "Saumya Sura",
                  style: GoogleFonts.merriweather(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "surasaumya17@gmail.com  •  Portfolio  •  GitHub/Saumya-sura  •  Linkedin/Saumya Sura",
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Flutter Developer  •  Springer research co-author  •  Cloud & DevOps Enthusiast",
                  style: GoogleFonts.sourceSans3(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Summary Section
          _buildSectionHeader("Summary"),
          const SizedBox(height: 4),
          Text(
            "Computer Engineering student with three software engineering internships spanning Flutter development and cloud infrastructure. Experienced in building mobile applications, automating deployment workflows, and deploying applications on Google Cloud. Springer research co-author (FICTA 2025) with a growing focus on DevOps, cloud-native systems, and infrastructure automation.",
            style: GoogleFonts.sourceSans3(fontSize: 11.5, height: 1.4, color: Colors.black87),
          ),

          const SizedBox(height: 14),

          // Experience Section
          _buildSectionHeader("Experience"),
          const SizedBox(height: 6),
          _buildExperienceItem(
            company: "Viscosity India",
            location: "Mumbai, India",
            role: "Tech Intern",
            period: "May 2026 - Sep 2026",
            bullets: [
              "Developed and deployed a new BODMAS Calculator feature, collaborating with the team to implement functionality and integrate it into the existing web application. Performed end-to-end website testing, identifying and validating bugs, ensuring feature quality.",
              "Collaborated on maintaining a GitHub Actions CI/CD pipeline, enabling automated deployments and reducing manual effort by delivering code changes directly to the server.",
            ],
          ),
          const SizedBox(height: 8),
          _buildExperienceItem(
            company: "Brown Bird Ventures",
            location: "Mumbai, India",
            role: "Flutter Intern",
            period: "Nov 2024 - Jan 2025",
            bullets: [
              "Built a Flutter application featuring AI-powered pet care recommendations and chatbot assistance, integrating the ChatGPT API and GetX to support personalized user interactions during testing.",
              "Designed an AI chatbot that generated pet-specific responses based on 5+ parameters (pet type, breed, age, weight, diet, etc.), improving recommendation accuracy and user relevance.",
            ],
          ),
          const SizedBox(height: 8),
          _buildExperienceItem(
            company: "Sayge Tech",
            location: "Mumbai, India",
            role: "Flutter Intern",
            period: "May 2025 - July 2025",
            bullets: [
              "Managed development and maintenance of 3 Flutter mobile applications, contributing to 20+ feature enhancements, UI improvements, and critical bug resolutions.",
              "Delivered client-specific customizations including branding updates, responsive layouts, and feature configuration across multiple projects, ensuring on-time project delivery.",
            ],
          ),

          const SizedBox(height: 14),

          // Projects Section
          _buildSectionHeader("Projects"),
          const SizedBox(height: 6),
          _buildProjectItem(
            title: "Scalable Web Infrastructure on Google Cloud Platform",
            category: "Cloud Infrastructure & Application Deployment",
            link: "",
            bullets: [
              "Designed a scalable web hosting infrastructure on Google Cloud Platform (GCP) using Compute Engine, Managed Instance Groups, HTTP(S) Load Balancer, and Cloud Storage.",
              "Configured secure networking with Google-managed SSL certificates, Identity and Access Management (IAM), VPC firewall rules, Cloud DNS, and automatic HTTP-to-HTTPS redirection.",
              "Automated application deployment and infrastructure management using Cloud Shell, SSH, Nginx, and the gcloud CLI, streamlining deployment workflows and server provisioning.",
            ],
          ),
          const SizedBox(height: 8),
          _buildProjectItem(
            title: "FindLy",
            category: "Real-Time Lost And Found System",
            link: "GitHub",
            bullets: [
              "Developed FindLy, a Flutter-based lost & found platform integrated with Supabase, implementing secure authentication, cloud storage, real-time database synchronization, and intelligent item matching using metadata-based filtering.",
              "Implemented offline data persistence, retry synchronization, privacy-focused contact sharing, and end-to-end status tracking, enhancing application reliability and scalability.",
            ],
          ),
          const SizedBox(height: 8),
          _buildProjectItem(
            title: "MPSTME OnTrack",
            category: "Campus Navigation and Alert Platform",
            link: "Website",
            bullets: [
              "Built a campus navigation system for MPSTME students to navigate easily through the university.",
              "Offline First Application, with over-the-air map updates and advertisement delivery for upcoming university events and important announcements.",
              "Developed using Flutter and deployed on Android and iOS with 1,500+ downloads.",
            ],
          ),

          const SizedBox(height: 14),

          // Leadership Experience Section
          _buildSectionHeader("LEADERSHIP EXPERIENCE"),
          const SizedBox(height: 6),
          Text(
            "FinDrome",
            style: GoogleFonts.sourceSans3(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 3),
          _buildLeadershipItem(
            role: "Managing Director",
            bullets: [
              "Orchestrated large-scale college fests and flagship events, mobilizing and directing a 100+ student workforce while optimizing inter-departmental workflows to guarantee seamless, on-time execution.",
              "Institutionalized operational frameworks across multiple departments, bridging communication gaps between technical, event, and logistical teams to elevate the overall quality of committee deliverables.",
            ],
          ),
          const SizedBox(height: 6),
          _buildLeadershipItem(
            role: "Tech Head",
            bullets: [
              "Directed the complete project lifecycle of technical initiatives from inception to deployment, translating broad organizational goals into strict development milestones.",
              "Managed and mentored a 6-member engineering team, optimizing development efforts and overseeing implementation to consistently deliver high-quality solutions on time.",
              "Also as an event Head successfully managing logistics, scheduling, and on-ground operations for 200+ attendees and seamless communication across multiple departments and coordinated with faculties.",
            ],
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Page 1 of 2",
              style: GoogleFonts.sourceSans3(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // --- PAGE 2: TECHNICAL SKILLS & EDUCATION ---
  Widget _buildPage2Card(Color themeColor) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 720),
      padding: const EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Technical Skills Section
          _buildSectionHeader("Technical Skills"),
          const SizedBox(height: 8),
          _buildSkillRow("Languages", "C++, Python, SQL, Java, Dart, Bash."),
          _buildSkillRow("Cloud & DevOps", "Docker, Linux, GCP, Terraform, Jenkins, Ansible."),
          _buildSkillRow("Backend", "Node.js, Express.js, Flask."),
          _buildSkillRow("Mobile Development", "Flutter, Supabase, Firebase, CI/CD."),

          const SizedBox(height: 24),

          // Education Section
          _buildSectionHeader("Education"),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mukesh Patel School of Technology Management and Engineering",
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "B.Tech in Computer Engineering",
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Mumbai, India",
                    style: GoogleFonts.sourceSans3(fontSize: 12, color: Colors.black87),
                  ),
                  Text(
                    "Expected Graduation: 2028",
                    style: GoogleFonts.sourceSans3(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rustomjee International School",
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "SSC",
                      style: GoogleFonts.sourceSans3(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "Mumbai, India",
                    style: GoogleFonts.sourceSans3(fontSize: 12, color: Colors.black87),
                  ),
                  Text(
                    "Graduated: 2022",
                    style: GoogleFonts.sourceSans3(
                      fontSize: 11.5,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Research Highlight Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.workspace_premium_rounded, color: Colors.amber.shade800, size: 22),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Springer Research Co-Author (FICTA 2025)",
                        style: GoogleFonts.sourceSans3(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber.shade900,
                        ),
                      ),
                      Text(
                        "Academic paper accepted for FICTA 2025 conference proceedings, published by Springer. Focused on cloud-native systems, automation, and computational engineering.",
                        style: GoogleFonts.sourceSans3(
                          fontSize: 11,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 120),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "Page 2 of 2",
              style: GoogleFonts.sourceSans3(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.merriweather(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 2),
        const Divider(color: Colors.black, thickness: 1.2, height: 4),
      ],
    );
  }

  Widget _buildExperienceItem({
    required String company,
    required String location,
    required String role,
    required String period,
    required List<String> bullets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              company,
              style: GoogleFonts.sourceSans3(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              location,
              style: GoogleFonts.sourceSans3(fontSize: 11.5, color: Colors.black87),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              role,
              style: GoogleFonts.sourceSans3(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87),
            ),
            Text(
              period,
              style: GoogleFonts.sourceSans3(fontSize: 11.5, fontStyle: FontStyle.italic, color: Colors.black87),
            ),
          ],
        ),
        const SizedBox(height: 3),
        for (var bullet in bullets)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("– ", style: TextStyle(fontSize: 11, color: Colors.black)),
                Expanded(
                  child: Text(
                    bullet,
                    style: GoogleFonts.sourceSans3(fontSize: 11, height: 1.35, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProjectItem({
    required String title,
    required String category,
    required String link,
    required List<String> bullets,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.sourceSans3(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            if (link.isNotEmpty)
              Text(
                link,
                style: GoogleFonts.sourceSans3(fontSize: 11.5, color: Colors.blue.shade900, decoration: TextDecoration.underline),
              ),
          ],
        ),
        Text(
          category,
          style: GoogleFonts.sourceSans3(fontSize: 11.5, fontStyle: FontStyle.italic, color: Colors.black87),
        ),
        const SizedBox(height: 3),
        for (var bullet in bullets)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("– ", style: TextStyle(fontSize: 11, color: Colors.black)),
                Expanded(
                  child: Text(
                    bullet,
                    style: GoogleFonts.sourceSans3(fontSize: 11, height: 1.35, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildLeadershipItem({required String role, required List<String> bullets}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("• ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(
              role,
              style: GoogleFonts.sourceSans3(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
        const SizedBox(height: 2),
        for (var bullet in bullets)
          Padding(
            padding: const EdgeInsets.only(bottom: 2.0, left: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("– ", style: TextStyle(fontSize: 11, color: Colors.black)),
                Expanded(
                  child: Text(
                    bullet,
                    style: GoogleFonts.sourceSans3(fontSize: 11, height: 1.35, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSkillRow(String category, String skills) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: "• ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12)),
            TextSpan(
              text: "$category: ",
              style: GoogleFonts.sourceSans3(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 12),
            ),
            TextSpan(
              text: skills,
              style: GoogleFonts.sourceSans3(color: Colors.black87, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
