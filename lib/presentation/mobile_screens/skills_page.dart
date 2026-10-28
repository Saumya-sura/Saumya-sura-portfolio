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
  // 1. Languages (From Resume)
  final List<Map<String, dynamic>> languages = [
    {"skillName": "C++", "icon": SimpleIcons.cplusplus},
    {"skillName": "Python", "icon": SimpleIcons.python},
    {"skillName": "SQL", "icon": Icons.storage_rounded},
    {"skillName": "Java", "icon": Icons.coffee_rounded},
    {"skillName": "Dart", "icon": SimpleIcons.dart},
    {"skillName": "Bash", "icon": SimpleIcons.gnubash},
    {"skillName": "C", "icon": SimpleIcons.c},
    {"skillName": "JavaScript", "icon": SimpleIcons.javascript},
  ];

  // 2. Cloud & DevOps (From Resume)
  final List<Map<String, dynamic>> cloudDevOps = [
    {"skillName": "GCP (Google Cloud)", "icon": SimpleIcons.googlecloud},
    {"skillName": "Docker", "icon": SimpleIcons.docker},
    {"skillName": "Linux", "icon": SimpleIcons.linux},
    {"skillName": "Terraform", "icon": SimpleIcons.terraform},
    {"skillName": "Jenkins", "icon": SimpleIcons.jenkins},
    {"skillName": "Ansible", "icon": SimpleIcons.ansible},
    {"skillName": "GitHub Actions", "icon": SimpleIcons.githubactions},
    {"skillName": "CI/CD", "icon": Icons.sync_alt_rounded},
    {"skillName": "Nginx", "icon": SimpleIcons.nginx},
    {"skillName": "Git & GitHub", "icon": SimpleIcons.github},
  ];

  // 3. Backend (From Resume)
  final List<Map<String, dynamic>> backend = [
    {"skillName": "Node.js", "icon": SimpleIcons.nodedotjs},
    {"skillName": "Express.js", "icon": SimpleIcons.express},
    {"skillName": "Flask", "icon": SimpleIcons.flask},
    {"skillName": "REST APIs", "icon": Icons.api_rounded},
    {"skillName": "MongoDB", "icon": SimpleIcons.mongodb},
    {"skillName": "Postman", "icon": SimpleIcons.postman},
  ];

  // 4. Mobile Development (From Resume)
  final List<Map<String, dynamic>> mobileDev = [
    {"skillName": "Flutter", "icon": SimpleIcons.flutter},
    {"skillName": "Supabase", "icon": SimpleIcons.supabase},
    {"skillName": "Firebase", "icon": SimpleIcons.firebase},
    {"skillName": "Mobile CI/CD", "icon": Icons.phone_android_rounded},
    {"skillName": "GetX", "icon": Icons.bolt_rounded},
    {"skillName": "Hive DB", "icon": Icons.inventory_2_outlined},
    {"skillName": "Android Studio", "icon": SimpleIcons.androidstudio},
    {"skillName": "VS Code", "icon": Icons.code_rounded},
    {"skillName": "Figma", "icon": SimpleIcons.figma},
  ];

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Technical Skills',
          style: TextStyle(
            color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cloud & DevOps Section
                    const DividerWithText(text: "Cloud & DevOps"),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: constraints.maxWidth > 600
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        for (var item in cloudDevOps)
                          SkillsChip(
                            skillName: item["skillName"],
                            icon: item["icon"],
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Mobile Development Section
                    const DividerWithText(text: "Mobile Development"),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: constraints.maxWidth > 600
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        for (var item in mobileDev)
                          SkillsChip(
                            skillName: item["skillName"],
                            icon: item["icon"],
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Languages Section
                    const DividerWithText(text: "Languages"),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: constraints.maxWidth > 600
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        for (var item in languages)
                          SkillsChip(
                            skillName: item["skillName"],
                            icon: item["icon"],
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Backend Section
                    const DividerWithText(text: "Backend & APIs"),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: constraints.maxWidth > 600
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      children: [
                        for (var item in backend)
                          SkillsChip(
                            skillName: item["skillName"],
                            icon: item["icon"],
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Core Proficiency Metrics
                    const DividerWithText(text: "Core Proficiency Metrics"),
                    const SizedBox(height: 12),
                    const SkillBar(
                      skill: "Flutter & Mobile Apps",
                      level: 0.95,
                      icon: SimpleIcons.flutter,
                      proficiencyLabel: "Production Ready",
                    ),
                    const SkillBar(
                      skill: "Cloud & DevOps (GCP, Docker, CI/CD)",
                      level: 0.88,
                      icon: SimpleIcons.googlecloud,
                      proficiencyLabel: "Advanced",
                    ),
                    const SkillBar(
                      skill: "Dart Ecosystem & State Management",
                      level: 0.92,
                      icon: SimpleIcons.dart,
                      proficiencyLabel: "Advanced",
                    ),
                    const SkillBar(
                      skill: "Backend (Node.js, Flask, Supabase)",
                      level: 0.85,
                      icon: SimpleIcons.nodedotjs,
                      proficiencyLabel: "Proficient",
                    ),
                    const SkillBar(
                      skill: "Python & AI API Integrations",
                      level: 0.85,
                      icon: SimpleIcons.python,
                      proficiencyLabel: "Proficient",
                    ),
                    const SkillBar(
                      skill: "Languages (C++, Java, SQL, Bash)",
                      level: 0.82,
                      icon: SimpleIcons.cplusplus,
                      proficiencyLabel: "Proficient",
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
