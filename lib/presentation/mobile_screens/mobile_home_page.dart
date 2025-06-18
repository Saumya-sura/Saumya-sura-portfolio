import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/color_provider.dart';
import 'about_page.dart';
import 'components/app_icon_card.dart';
import 'components/link_icon_card.dart';
import 'education_page.dart';
import 'projects_page.dart';
import 'skills_page.dart';

class MobileHomePage extends StatefulWidget {
  const MobileHomePage({super.key, this.color = Colors.blue});

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
  Widget build(BuildContext context) {
    if (context.watch<ColorProvider>().color != widget.color) {
      Future.delayed(const Duration(milliseconds: 100), () {
        context.read<ColorProvider>().setColor(widget.color);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Portfolio',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.watch<ColorProvider>().color,
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              context.watch<ColorProvider>().color.withOpacity(0.8),
              context.watch<ColorProvider>().color.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    final items = [
                      AppIconCard(
                        title: "About Me",
                        icon: Icons.person,
                        onTap: AboutPage(),
                      ),
                      AppIconCard(
                        title: "Projects",
                        icon: Icons.code,
                        onTap: ProjectsPage(),
                      ),
                      AppIconCard(
                        title: "Skills",
                        icon: Icons.star,
                        onTap: SkillsPage(),
                      ),
                      AppIconCard(
                        title: "Education",
                        icon: Icons.school,
                        onTap: EducationPage(),
                      ),
                      LinkIconCard(
                        title: "GitHub",
                        icon: SimpleIcons.github,
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://github.com/Saumya-sura"),
                          );
                        },
                      ),
                      LinkIconCard(
                        title: "Email",
                        icon: Icons.mail,
                        onTap: () {
                          launchUrl(
                            Uri.parse("mailto:surasaumya17@protonmail.com"),
                          );
                        },
                      ),
                      LinkIconCard(
                        title: "Instagram",
                        icon: SimpleIcons.instagram,
                        onTap: () {
                          launchUrl(
                            Uri.parse(
                                "https://www.instagram.com/saumyasura/"),
                          );
                        },
                      ),                      LinkIconCard(
                        title: "LinkedIn",
                        icon: SimpleIcons.linkedin,
                        onTap: () {
                          launchUrl(
                            Uri.parse("https://www.linkedin.com/in/saumya-sura-a73734270/"),
                          );
                        },
                      ),
                    ];
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(15),
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
              const SizedBox(height: 16),              Text(
                "Developed by Saumya Sura",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1,
                  color: context.watch<ColorProvider>().color.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
