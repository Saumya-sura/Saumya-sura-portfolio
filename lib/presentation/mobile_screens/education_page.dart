import 'package:flutter/material.dart';
import 'package:portfolio_website/presentation/mobile_screens/components/education_card.dart';

import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';

class EducationPage extends StatefulWidget {
  const EducationPage({super.key});

  @override
  State<EducationPage> createState() => _EducationPageState();
}

class _EducationPageState extends State<EducationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: context.watch<ColorProvider>().color.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
        ),
        centerTitle: true,
        title: Text(
          'Education',
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
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              children: [
                Center(
                  child: Icon(
                    Icons.school,
                    size: screenWidth < 600
                        ? screenWidth * 0.75
                        : screenWidth * 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                const EducationCard(
                  title: "Pursuing B.Tech in Computer Engineering",
                  instituteName:
                      "Mukesh Patel School of Technology Management and Engineering",
                  duration: "2022 - 2028",
                  url: "https://engineering.nmims.edu/",
                ),
                const SizedBox(height: 20),
                const EducationCard(
                  title: "SSC",
                  instituteName: "Rustomjee International School",
                  duration: "2010 - 2022",
                  url: "",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
