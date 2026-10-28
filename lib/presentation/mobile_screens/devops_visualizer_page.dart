import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../providers/color_provider.dart';
import 'components/cicd_pipeline_widget.dart';
import 'components/gcp_architecture_diagram.dart';

class DevOpsVisualizerPage extends StatefulWidget {
  const DevOpsVisualizerPage({
    super.key,
    this.initialTab = 0,
  });

  final int initialTab; // 0: GCP Architecture, 1: CI/CD Pipeline

  @override
  State<DevOpsVisualizerPage> createState() => _DevOpsVisualizerPageState();
}

class _DevOpsVisualizerPageState extends State<DevOpsVisualizerPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'DevOps & Cloud Lab',
          style: TextStyle(
            color: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          indicatorWeight: 3,
          labelColor: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          unselectedLabelColor: themeColor.computeLuminance() > 0.5
              ? Colors.black54
              : Colors.white60,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(
              icon: Icon(SimpleIcons.googlecloud, size: 16),
              text: "GCP Architecture",
            ),
            Tab(
              icon: Icon(SimpleIcons.githubactions, size: 16),
              text: "CI/CD Pipeline",
            ),
          ],
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: const [
            // Tab 1: GCP Architecture Diagram
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Column(
                children: [
                  GcpArchitectureDiagram(),
                  SizedBox(height: 20),
                ],
              ),
            ),

            // Tab 2: CI/CD Pipeline Simulator
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              child: Column(
                children: [
                  CicdPipelineWidget(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
