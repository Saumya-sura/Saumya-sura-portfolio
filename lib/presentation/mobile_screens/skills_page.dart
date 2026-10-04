import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../providers/color_provider.dart';
import 'components/divider_with_text.dart';
import 'components/skills_chip.dart';
import 'components/skill_bar.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  List<Map<String, dynamic>> languages = [
    {
      "skillName": "C",
      "icon": SimpleIcons.c,
    },
    {
      "skillName": "C++",
      "icon": SimpleIcons.cplusplus,
    },
    {
      "skillName": "Python",
      "icon": SimpleIcons.python,
    },
    {
      "skillName": "Dart",
      "icon": SimpleIcons.dart,
    },
    {
      "skillName": "Kotlin",
      "icon": SimpleIcons.kotlin,
    },
    {
      "skillName": "Javascript",
      "icon": SimpleIcons.javascript,
    },
   
  ];

  List<Map<String, dynamic>> librariesAndFrameworks = [
    {
      "skillName": "Flutter",
      "icon": SimpleIcons.flutter,
    },
    
   
    {
      "skillName": "Node.js",
      "icon": SimpleIcons.nodedotjs,
    },
    {
      "skillName": "Express.js",
      "icon": SimpleIcons.express,
    },
    
     
    {
      "skillName": "Bootstrap",
      "icon": SimpleIcons.bootstrap,
    },
   
   
  ];

  List<Map<String, dynamic>> tools = [
    {
      "skillName": "VSCode",
      "icon": Icons.code,
    },
    {
      "skillName": "Android Studio",
      "icon": SimpleIcons.androidstudio,
    },
   
    {
      "skillName": "Windows",
      "icon": Icons.grid_view,
    },
   
    {
      "skillName": "Ubuntu",
      "icon": SimpleIcons.ubuntu,
    },
   
    {
      "skillName": "Postman",
      "icon": SimpleIcons.postman,
    },
    {
      "skillName": "Git",
      "icon": SimpleIcons.git,
    },
    {
      "skillName": "GitHub",
      "icon": SimpleIcons.github,
    },
    {
      "skillName": "GitLab",
      "icon": SimpleIcons.docker,
    },
    {
      "skillName": "GitHub Actions",
      "icon": SimpleIcons.githubactions,
    },
    {
      "skillName": "Netlify",
      "icon": SimpleIcons.netlify,
    },
    {
      "skillName": "MongoDB",
      "icon": SimpleIcons.mongodb,
    },
   
    
    {
      "skillName": "Google Colab",
      "icon": SimpleIcons.googlecolab,
    },
    {
      "skillName": "Jupyter",
      "icon": SimpleIcons.jupyter,
    },
    
   
    {
      "skillName": "Firebase",
      "icon": SimpleIcons.firebase,
    },
    {
      "skillName": "Supabase",
      "icon": SimpleIcons.supabase,
    },
    {
      "skillName": "Appwrite",
      "icon": SimpleIcons.appwrite,
    },
    {
      "skillName": "Figma",
      "icon": SimpleIcons.figma,
    },
    {
      "skillName": "Wix",
      "icon": SimpleIcons.wix,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.watch<ColorProvider>().color.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Skills',
          style: TextStyle(
            color: context.watch<ColorProvider>().color.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
          ),
        ),
        backgroundColor: context.watch<ColorProvider>().color,
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
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DividerWithText(text: "Languages"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: constraints.maxWidth > 600
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        for (int i = 0; i < languages.length; i++)
                          SkillsChip(
                            skillName: languages[i]["skillName"],
                            icon: languages[i]["icon"],
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const DividerWithText(text: "Libraries/Frameworks"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: constraints.maxWidth > 600
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        for (int i = 0; i < librariesAndFrameworks.length; i++)
                          SkillsChip(
                            skillName: librariesAndFrameworks[i]["skillName"],
                            icon: librariesAndFrameworks[i]["icon"],
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const DividerWithText(text: "Tools"),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: constraints.maxWidth > 600
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        for (int i = 0; i < tools.length; i++)
                          SkillsChip(
                            skillName: tools[i]["skillName"],
                            icon: tools[i]["icon"],
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 24),
                    const DividerWithText(text: "Core Proficiency Metrics"),
                    const SizedBox(height: 12),
                    const SkillBar(
                      skill: "Flutter & Mobile Apps",
                      level: 0.95,
                      icon: SimpleIcons.flutter,
                      proficiencyLabel: "Production Ready",
                    ),
                    const SkillBar(
                      skill: "Dart Ecosystem",
                      level: 0.90,
                      icon: SimpleIcons.dart,
                      proficiencyLabel: "Advanced",
                    ),
                    const SkillBar(
                      skill: "Firebase & Cloud Backends",
                      level: 0.85,
                      icon: SimpleIcons.firebase,
                      proficiencyLabel: "Advanced",
                    ),
                    const SkillBar(
                      skill: "Python & Gemini AI APIs",
                      level: 0.82,
                      icon: SimpleIcons.python,
                      proficiencyLabel: "Proficient",
                    ),
                    const SkillBar(
                      skill: "C / C++ & DSA",
                      level: 0.80,
                      icon: SimpleIcons.cplusplus,
                      proficiencyLabel: "Proficient",
                    ),
                    const SkillBar(
                      skill: "Node.js & REST APIs",
                      level: 0.78,
                      icon: SimpleIcons.nodedotjs,
                      proficiencyLabel: "Intermediate",
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
