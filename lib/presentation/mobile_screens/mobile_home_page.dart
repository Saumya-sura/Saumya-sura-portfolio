import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/color_provider.dart';
import '../../providers/phone_state_provider.dart';
import 'about_page.dart';
import 'components/app_icon_card.dart';
import 'components/link_icon_card.dart';
import 'components/phone_status_bar.dart';
import 'education_page.dart';
import 'projects_page.dart';
import 'skills_page.dart';
import 'terminal_page.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key, this.color = Colors.black});

  final Color color;

  @override
  State<MobileHomePage> createState() => _MobileHomePageState();
}

class _MobileHomePageState extends State<MobileHomePage>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Tween<double>? _tween;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _tween = Tween<double>(begin: 0, end: 1);
    _tween!.animate(_animationController!).addListener(() {
      setState(() {});
    });
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController!.forward(from: 0);
      }
    });
    _animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isLight = themeColor.computeLuminance() > 0.5;
    final textColor = isLight ? Colors.black : Colors.white;

    final items = [
      AppIconCard(
        title: "About Me",
        icon: Icons.person_rounded,
        onTap: const AboutPage(),
      ),
      AppIconCard(
        title: "Projects",
        icon: Icons.code_rounded,
        onTap: const ProjectsPage(),
      ),
      AppIconCard(
        title: "Skills",
        icon: Icons.auto_awesome_rounded,
        onTap: const SkillsPage(),
      ),
      AppIconCard(
        title: "Education",
        icon: Icons.school_rounded,
        onTap: const EducationPage(),
      ),
      AppIconCard(
        title: "Terminal",
        icon: Icons.terminal_rounded,
        onTap: const TerminalPage(),
      ),
      LinkIconCard(
        title: "GitHub",
        icon: SimpleIcons.github,
        onTap: () {
          launchUrl(Uri.parse("https://github.com/Saumya-sura"));
        },
      ),
      LinkIconCard(
        title: "Email",
        icon: Icons.mail_rounded,
        onTap: () {
          launchUrl(Uri.parse("mailto:surasaumya17@protonmail.com"));
        },
      ),
      LinkIconCard(
        title: "LinkedIn",
        icon: Text(
          "in",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            fontFamily: 'sans-serif',
            color: isLight ? Colors.black : Colors.white,
          ),
        ),
        onTap: () {
          launchUrl(Uri.parse("https://www.linkedin.com/in/saumya-sura-a73734270/"));
        },
      ),
      LinkIconCard(
        title: "Instagram",
        icon: SimpleIcons.instagram,
        onTap: () {
          launchUrl(Uri.parse("https://www.instagram.com/saumyasura/"));
        },
      ),
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeColor.withOpacity(0.85),
              themeColor.withOpacity(0.45),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Realistic Status Bar & Interactive Dynamic Island
              PhoneStatusBar(isDarkBackground: !isLight),

              const SizedBox(height: 10),

              // Mobile App Header / Portfolio Branding
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saumya Sura',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                            color: textColor,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Flutter & Web Developer',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    Tooltip(
                      message: "Virtual Phone Simulator",
                      child: GestureDetector(
                        onTap: () {
                          context.read<PhoneStateProvider>().triggerNotification(
                                title: "Virtual Phone 📱",
                                subtitle: "Interactive mobile phone simulation",
                                icon: Icons.phone_iphone_rounded,
                                iconColor: Colors.cyanAccent,
                              );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.phone_iphone_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // App Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: GridView.builder(
                    padding: const EdgeInsets.only(bottom: 12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.95,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).cardColor.withOpacity(0.92),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: items[index],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Bottom OS Indicator / Home Indicator Bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10, top: 4),
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
