import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/color_provider.dart';
import 'components/divider_with_text.dart';
import 'components/hobby_card.dart';
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
      duration: const Duration(seconds: 1),
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
          ),
        ),
        backgroundColor: themeColor,
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
                  // Avatar stack with pulse status badge
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
                        ),
                        child: const CircleAvatar(
                          radius: 80,
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
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const PulsingStatusWidget(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Saumya Sura',
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 36 : 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Web and Mobile Development Enthusiast',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 20 : 16,
                      fontWeight: FontWeight.w500,
                      color: themeColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mukesh Patel School of Technology Management and Engineering, Mumbai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 16 : 14,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Resume Action Button
                  const DownloadResumeButton(),
                  const SizedBox(height: 24),
                  // Hobbies Section
                  const DividerWithText(text: "My Interests"),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      HobbyCard(
                        title: "App Dev",
                        icon: Icons.phone_android_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "Web Dev",
                        icon: Icons.language_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "UI/UX Design",
                        icon: Icons.palette_rounded,
                        color: themeColor,
                      ),
                      HobbyCard(
                        title: "Chess",
                        icon: Icons.grid_on_rounded,
                        color: themeColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  // Timeline / My Journey Section
                  const DividerWithText(text: "My Journey"),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      TimelineItem(
                        title: "B.Tech in Computer Engineering",
                        subtitle: "Started B.Tech at NMIMS' MPSTME, Mumbai.",
                        date: "2022",
                        icon: Icons.school,
                        color: themeColor,
                      ),
                      TimelineItem(
                        title: "MPSTME OnTrack Launch",
                        subtitle: "Developed & launched schedules app. Reached 1400+ downloads on stores.",
                        date: "2023",
                        icon: Icons.rocket_launch,
                        color: themeColor,
                      ),
                      TimelineItem(
                        title: "TOT App & AI Experiments",
                        subtitle: "Created an app for Pet Owners with Hive, Firebase, and AI APIs.",
                        date: "2024",
                        icon: Icons.code,
                        color: themeColor,
                      ),
                      TimelineItem(
                        title: "Present",
                        subtitle: "Building complex Flutter/Web architectures. Open to Internships!",
                        date: "2026",
                        icon: Icons.workspace_premium,
                        isLast: true,
                        color: themeColor,
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
          "Available for Internships",
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

class DownloadResumeButton extends StatefulWidget {
  const DownloadResumeButton({super.key});

  @override
  State<DownloadResumeButton> createState() => _DownloadResumeButtonState();
}

class _DownloadResumeButtonState extends State<DownloadResumeButton> {
  bool _isDownloading = false;

  void _handleDownload() async {
    setState(() {
      _isDownloading = true;
    });

    // Simulate downloading latency
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isDownloading = false;
      });

      // Recruiter will be redirected to GitHub or interactive site link
      final uri = Uri.parse("https://github.com/Saumya-sura");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          foregroundColor: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: _isDownloading ? null : _handleDownload,
        icon: _isDownloading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  ),
                ),
              )
            : const Icon(Icons.download_rounded),
        label: Text(
          _isDownloading ? "Downloading..." : "Download Resume",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
