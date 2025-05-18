import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/color_provider.dart';
import 'components/project_card.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

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
          'Projects',
          style: TextStyle(
            color: context.watch<ColorProvider>().color.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white,
          ),
        ),
        backgroundColor: context.watch<ColorProvider>().color,
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ProjectCard(
              projectName: 'TOT App',
              projectDescription:
                  'An App for Pet Owners.',
              projectLink:
                  'https://play.google.com/store/apps/details?id=com.skvjum.skvjum_app',
              projectTechnologies: [
                'Flutter',
                'Firebase',
                'Hive',
                'Open AI API',
                'Google Play Store',
              ],
            ),
            ProjectCard(
              projectName: 'MPSTME OnTrack',
              projectDescription:
                  'MPSTME OnTrack is built with an aim of never letting anyone from MPSTME get late to a lecture searching for their class. MPSTME OnTrack allows a user to store their schedule with their class details. Currently has 1400+ downloads on Play Store and App Store combined.',
              projectLink: 'https://ontrack.gdscmpstme.com/',
              projectTechnologies: [
                'Flutter',
                'Google Play Store',
                'Apple App Store',
              ],
            ),
            ProjectCard(
              projectName: 'WellVerse',
              projectDescription:
                  ' An app for Mantra meditation.',
              projectLink: 'https://code.mpst.me/',
              projectTechnologies: [
               'flutter',
                'SQLite',
                
              ],
            ),
            ProjectCard(
              projectName: 'Fitness Tracking App',
              projectDescription:
                  ' Fitness app with AI-powered food suggestions.',
              projectLink: 'https://chess.manangandhi.tech/',
              projectTechnologies: [
                'Flutter',
                'Gemini APi'
              ],
            ), 
          ],
        ),
      ),
    );
  }
}