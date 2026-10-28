import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:simple_icons/simple_icons.dart';

import '../../../providers/color_provider.dart';
import '../../../providers/phone_state_provider.dart';
import '../../../services/sound_service.dart';

class CicdPipelineWidget extends StatefulWidget {
  const CicdPipelineWidget({super.key});

  @override
  State<CicdPipelineWidget> createState() => _CicdPipelineWidgetState();
}

enum PipelineStatus { idle, running, success, failed }

class PipelineStage {
  final String id;
  final String name;
  final String description;
  final String duration;
  final IconData icon;
  final List<String> logs;
  final String yamlSnippet;
  bool isCompleted;
  bool isCurrent;

  PipelineStage({
    required this.id,
    required this.name,
    required this.description,
    required this.duration,
    required this.icon,
    required this.logs,
    required this.yamlSnippet,
    this.isCompleted = false,
    this.isCurrent = false,
  });
}

class _CicdPipelineWidgetState extends State<CicdPipelineWidget> {
  PipelineStatus _status = PipelineStatus.idle;
  int _activeStageIndex = 0;
  int? _selectedStageDetailIndex;
  Timer? _runnerTimer;
  int _elapsedSeconds = 0;

  late List<PipelineStage> _stages;

  @override
  void initState() {
    super.initState();
    _resetStages();
    _selectedStageDetailIndex = 2; // Default selected: Automated Testing
  }

  void _resetStages() {
    _stages = [
      PipelineStage(
        id: "checkout",
        name: "1. Checkout & Setup",
        description: "Fetch repo & setup Flutter/Node runner environment",
        duration: "8s",
        icon: SimpleIcons.github,
        logs: [
          "Run actions/checkout@v4",
          "Syncing repository: Saumya-sura/web-portfolio",
          "Fetching submodules & depth=1 commit: #b84f29a",
          "[OK] Setup Flutter v3.24.3 (channel stable) & Dart SDK v3.5.3",
        ],
        yamlSnippet: "- name: Checkout repository\n  uses: actions/checkout@v4\n- name: Set up Flutter\n  uses: subosito/flutter-action@v2\n  with:\n    flutter-version: '3.24.3'",
      ),
      PipelineStage(
        id: "lint",
        name: "2. Lint & Code Quality",
        description: "Static code analysis, formatting & security audit",
        duration: "14s",
        icon: Icons.checklist_rounded,
        logs: [
          "Run flutter analyze --fatal-infos",
          "Analyzing workspace directories ...",
          "No syntax or lint errors found.",
          "[OK] Security audit: 0 high, 0 critical vulnerabilities.",
        ],
        yamlSnippet: "- name: Analyze & Lint Code\n  run: |\n    flutter analyze\n    flutter format --set-exit-if-changed .",
      ),
      PipelineStage(
        id: "test",
        name: "3. Automated Testing",
        description: "Unit testing, BODMAS calculator & E2E feature verification",
        duration: "26s",
        icon: Icons.science_rounded,
        logs: [
          "Run flutter test --coverage",
          "Running test/calculator_test.dart ... PASS (0.4s)",
          "Running test/bodmas_rules_test.dart ... PASS (0.2s)",
          "Running test/e2e_integration_test.dart ... PASS (1.1s)",
          "[OK] All 14 test suites passed (100% test pass rate)",
        ],
        yamlSnippet: "- name: Run Unit & E2E Tests\n  run: |\n    flutter test --coverage\n    bash <(curl -s https://codecov.io/bash)",
      ),
      PipelineStage(
        id: "build",
        name: "4. Build & Containerize",
        description: "Compile production bundle & build optimized Docker image",
        duration: "38s",
        icon: SimpleIcons.docker,
        logs: [
          "Run docker build -t gcr.io/viscosity-prod/app:v2.6.4 .",
          "Step 1/8 : FROM nginx:alpine",
          "Step 2/8 : COPY ./build/web /usr/share/nginx/html",
          "Step 3/8 : COPY ./nginx.conf /etc/nginx/conf.d/default.conf",
          "Successfully tagged gcr.io/viscosity-prod/app:v2.6.4",
          "[OK] Image size: 28.4MB (compressed)",
        ],
        yamlSnippet: "- name: Build Docker Image\n  run: |\n    docker build -t gcr.io/viscosity-prod/app:\${{ github.sha }} .\n    docker push gcr.io/viscosity-prod/app:\${{ github.sha }}",
      ),
      PipelineStage(
        id: "deploy",
        name: "5. Deploy to GCP Server",
        description: "Authenticate GCP IAM, SSH to VM & execute zero-downtime rolling reload",
        duration: "16s",
        icon: SimpleIcons.googlecloud,
        logs: [
          "Run google-github-actions/auth@v2",
          "Authenticated via Workload Identity Federation",
          "Target: Compute Engine VM (web-mig-us-central1)",
          "Running remote: sudo systemctl reload nginx",
          "HTTP Health Check probe: 200 OK (latency 18ms)",
          "[SUCCESS] Production release deployed with 0 downtime!",
        ],
        yamlSnippet: "- name: Deploy to GCP Compute Engine\n  uses: google-github-actions/deploy-cloudrun@v2\n  with:\n    service: web-service\n    image: gcr.io/viscosity-prod/app:\${{ github.sha }}\n    region: us-central1",
      ),
    ];
  }

  void _runPipeline() {
    if (_status == PipelineStatus.running) return;

    SoundService().playClick();

    setState(() {
      _resetStages();
      _status = PipelineStatus.running;
      _activeStageIndex = 0;
      _elapsedSeconds = 0;
      _stages[0].isCurrent = true;
      _selectedStageDetailIndex = 0;
    });

    _runnerTimer?.cancel();
    _runnerTimer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _elapsedSeconds += 2;
        if (_activeStageIndex < _stages.length) {
          _stages[_activeStageIndex].isCompleted = true;
          _stages[_activeStageIndex].isCurrent = false;
          SoundService().playPop();

          _activeStageIndex++;
          if (_activeStageIndex < _stages.length) {
            _stages[_activeStageIndex].isCurrent = true;
            _selectedStageDetailIndex = _activeStageIndex;
          } else {
            // Finished all stages
            _status = PipelineStatus.success;
            _selectedStageDetailIndex = _stages.length - 1;
            SoundService().playSuccess();
            timer.cancel();

            try {
              context.read<PhoneStateProvider>().triggerNotification(
                    title: "Deploy Success 🚀",
                    subtitle: "Zero-downtime release live on GCP Compute Engine!",
                    icon: Icons.cloud_done_rounded,
                    iconColor: Colors.greenAccent,
                  );
            } catch (_) {}
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _runnerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedStage = _selectedStageDetailIndex != null
        ? _stages[_selectedStageDetailIndex!]
        : _stages[2];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131A24) : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: themeColor.withOpacity(0.35),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Pipeline Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A2332) : Colors.white,
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
                    color: themeColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    SimpleIcons.githubactions,
                    color: themeColor,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "GitHub Actions CI/CD",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black38 : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "main",
                              style: GoogleFonts.firaCode(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Viscosity India • Automated Server Deployments",
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // Run Pipeline Action Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: themeColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _runPipeline,
                  icon: Icon(
                    _status == PipelineStatus.running
                        ? Icons.hourglass_top_rounded
                        : Icons.play_arrow_rounded,
                    size: 14,
                  ),
                  label: Text(
                    _status == PipelineStatus.running
                        ? "Running..."
                        : (_status == PipelineStatus.success ? "Re-run" : "Run CI/CD"),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Commit & Workflow Info Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            color: isDark ? const Color(0xFF161E2B) : const Color(0xFFEFF3F8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.commit_rounded,
                      size: 14,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "b84f29a (BODMAS Calculator & CI/CD)",
                      style: GoogleFonts.firaCode(
                        fontSize: 10.5,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(),
              ],
            ),
          ),

          // Pipeline Stages Flow List
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                for (int i = 0; i < _stages.length; i++) ...[
                  _buildStageCard(i, themeColor, isDark),
                  if (i < _stages.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Container(
                        width: 2,
                        height: 10,
                        color: _stages[i].isCompleted
                            ? Colors.greenAccent.shade400
                            : (isDark ? Colors.white12 : Colors.black12),
                      ),
                    ),
                ],
              ],
            ),
          ),

          // Stage Details & Live Console Logs
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2838) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: themeColor.withOpacity(0.35),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(selectedStage.icon, size: 16, color: themeColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${selectedStage.name} • Stage Console",
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      "Duration: ${selectedStage.duration}",
                      style: GoogleFonts.firaCode(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Terminal Log Window
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C1017),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var line in selectedStage.logs)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.5),
                          child: SelectableText(
                            line,
                            style: GoogleFonts.firaCode(
                              fontSize: 10,
                              color: line.startsWith("[SUCCESS]")
                                  ? Colors.greenAccent
                                  : (line.startsWith("[OK]")
                                      ? Colors.cyanAccent
                                      : Colors.white70),
                              height: 1.35,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // YAML Workflow Definition Snippet
                Row(
                  children: [
                    const Icon(Icons.code, size: 12, color: Colors.amberAccent),
                    const SizedBox(width: 4),
                    Text(
                      ".github/workflows/deploy.yml (Step Configuration)",
                      style: GoogleFonts.firaCode(
                        fontSize: 10,
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F141C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    selectedStage.yamlSnippet,
                    style: GoogleFonts.firaCode(
                      fontSize: 9.5,
                      color: Colors.amber.shade200,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageCard(int index, Color themeColor, bool isDark) {
    final stage = _stages[index];
    final isSelected = _selectedStageDetailIndex == index;

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.radio_button_unchecked;

    if (stage.isCompleted) {
      statusColor = Colors.greenAccent.shade400;
      statusIcon = Icons.check_circle_rounded;
    } else if (stage.isCurrent) {
      statusColor = Colors.cyanAccent;
      statusIcon = Icons.sync_rounded;
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStageDetailIndex = index;
        });
        SoundService().playClick();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.withOpacity(isDark ? 0.2 : 0.1)
              : (isDark ? const Color(0xFF1B2330) : Colors.white),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? themeColor
                : (stage.isCompleted ? Colors.greenAccent.withOpacity(0.4) : (isDark ? Colors.white12 : Colors.black12)),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              statusIcon,
              size: 16,
              color: statusColor,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(stage.icon, size: 14, color: themeColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? themeColor : null,
                    ),
                  ),
                  Text(
                    stage.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              stage.duration,
              style: GoogleFonts.firaCode(
                fontSize: 10,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String text = "IDLE";
    Color color = Colors.grey;

    if (_status == PipelineStatus.running) {
      text = "RUNNING (${_elapsedSeconds}s)";
      color = Colors.cyanAccent;
    } else if (_status == PipelineStatus.success) {
      text = "PASSED";
      color = Colors.greenAccent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
