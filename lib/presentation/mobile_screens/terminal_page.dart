import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/color_provider.dart';
import '../../providers/phone_state_provider.dart';
import '../../services/sound_service.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> _history = [];
  bool _matrixMode = false;
  bool _isBooting = true;

  final List<String> _quickCommands = [
    'help',
    'about',
    'architecture',
    'cicd',
    'experience',
    'projects',
    'skills',
    'leadership',
    'research',
    'education',
    'contact',
    'hire',
    'matrix',
    'clear',
  ];

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  void _startBootSequence() async {
    final bootLines = [
      '[OK] Initializing SAUMYA-OS v2.8 (arm64/linux) ...',
      '[OK] Mounting /home/saumya/resume_data ...',
      '[OK] Loading GCP Cloud Shell & Docker daemon ...',
      '────────────────────────────────────────────────────────',
      'SAUMYA SURA • Interactive Terminal v2.8',
      'Flutter Developer • Springer Co-Author • Cloud & DevOps',
      "Type 'help' or tap command chips below to explore.",
      '────────────────────────────────────────────────────────',
    ];

    for (var line in bootLines) {
      await Future.delayed(const Duration(milliseconds: 160));
      if (mounted) {
        setState(() {
          _history.add({'type': 'system', 'text': line});
        });
        _scrollToBottom();
      }
    }

    if (mounted) {
      setState(() {
        _isBooting = false;
      });

      try {
        context.read<PhoneStateProvider>().triggerNotification(
              title: 'Terminal Online 💻',
              subtitle: "Try 'architecture', 'cicd', or 'experience'",
              icon: Icons.terminal_rounded,
              iconColor: Colors.greenAccent,
            );
      } catch (_) {}
    }
  }

  void _handleCommand(String rawCommand) {
    final cmd = rawCommand.trim().toLowerCase();
    _inputController.clear();

    if (cmd.isEmpty) return;

    SoundService().playKey();

    setState(() {
      _history.add({'type': 'input', 'text': 'saumya@portfolio:~\$ $rawCommand'});
    });

    switch (cmd) {
      case 'help':
        _addOutput([
          'AVAILABLE COMMANDS:',
          '  about         - Summary, headline & background info',
          '  architecture  - Interactive GCP cloud infrastructure topology',
          '  cicd          - GitHub Actions 5-stage automated deployment pipeline',
          '  experience    - 3 Software engineering internships',
          '  projects      - Cloud infra & mobile flagship projects',
          '  skills        - Technical skills across DevOps, Mobile, Backend',
          '  leadership    - FinDrome Managing Director & Tech Head',
          '  research      - Springer Research Co-Author (FICTA 2025)',
          '  education     - B.Tech @ MPSTME (2028) & SSC @ Rustomjee',
          '  contact       - Email, GitHub, LinkedIn details',
          '  hire          - Open email client for immediate hire/internship',
          '  matrix        - Toggle animated Matrix digital rain',
          '  clear         - Clear the screen',
          '  sudo          - Execute command with elevated permissions',
        ]);
        break;

      case 'architecture':
      case 'gcp':
        _addOutput([
          'GCP INFRASTRUCTURE TOPOLOGY:',
          '1. Google Cloud DNS: Global Anycast routing & SSL domain validation',
          '2. HTTP(S) Load Balancer: Auto SSL termination (Google-managed), HTTP->HTTPS 301',
          '3. VPC Firewall & IAM: Strict ingress CIDRs, IAP Bastion, least privilege',
          '4. Compute Engine MIG: Autoscaling Nginx reverse proxies, health check auto-healing',
          '5. Cloud Storage (GCS): Multi-regional media & static asset hosting',
          '6. gcloud Automation: Cloud Shell CLI scripts for automated server updates',
        ]);
        break;

      case 'cicd':
      case 'pipeline':
        _addOutput([
          'GITHUB ACTIONS CI/CD PIPELINE FLOW:',
          '• Stage 1 [Checkout]: actions/checkout@v4 + Flutter SDK v3.24.3 setup',
          '• Stage 2 [Lint]: flutter analyze --fatal-infos (0 errors, 100% clean)',
          '• Stage 3 [Testing]: flutter test --coverage (14/14 test suites passed)',
          '• Stage 4 [Docker]: Multi-stage container build -> gcr.io/viscosity-prod/app',
          '• Stage 5 [Deploy]: Google IAM authentication -> SSH Compute Engine VM reload',
          'Status: PASSING (Average duration: 1m 42s)',
        ]);
        break;

      case 'about':
        _addOutput([
          'SAUMYA SURA',
          'Flutter Developer • Springer Research Co-Author • Cloud & DevOps Enthusiast',
          '• Computer Engineering student at MPSTME (NMIMS), Mumbai',
          '• Completed 3 software engineering internships spanning Flutter & Cloud',
          '• Experienced in deploying cloud infrastructure on GCP & CI/CD automation',
          '• Springer research co-author (FICTA 2025)',
        ]);
        break;

      case 'experience':
        _addOutput([
          'SOFTWARE ENGINEERING INTERNSHIPS:',
          '',
          '1. Viscosity India (Tech Intern) | May 2026 - Sep 2026 | Mumbai, India',
          '   • Developed & deployed BODMAS Calculator, integrated into web app.',
          '   • Maintained automated GitHub Actions CI/CD pipeline delivering to server.',
          '',
          '2. Brown Bird Ventures (Flutter Intern) | Nov 2024 - Jan 2025 | Mumbai, India',
          '   • Built AI-powered pet care recommendations & chatbot using ChatGPT API & GetX.',
          '   • Designed chatbot with 5+ parameters (breed, age, weight, diet) improving accuracy.',
          '',
          '3. Sayge Tech (Flutter Intern) | May 2025 - July 2025 | Mumbai, India',
          '   • Managed 3 Flutter apps, delivering 20+ feature enhancements & UI upgrades.',
          '   • Delivered client-specific branding, responsive layouts, & configurations.',
        ]);
        break;

      case 'projects':
        _addOutput([
          'FLAGSHIP PROJECTS:',
          '',
          '1. Scalable Web Infrastructure on Google Cloud Platform (GCP)',
          '   • Compute Engine, Managed Instance Groups, HTTP(S) Load Balancer, Cloud Storage.',
          '   • Google-managed SSL, IAM, VPC firewalls, Cloud DNS, automatic HTTPS redirect.',
          '   • Automated deployments via Cloud Shell, SSH, Nginx, and gcloud CLI.',
          '',
          '2. FindLy (Real-Time Lost And Found System)',
          '   • Flutter + Supabase lost & found platform with metadata-based filtering.',
          '   • Offline persistence, retry synchronization, & privacy contact sharing.',
          '',
          '3. MPSTME OnTrack (Campus Navigation & Alert Platform)',
          '   • Offline-first campus map & timetable navigation with over-the-air updates.',
          '   • 1,500+ downloads on Apple App Store & Google Play Store.',
          '',
          '4. Brown Bird Pet Care AI (TOT App)',
          '   • AI pet recommendations, Hive DB, Firebase, and OpenAI API.',
        ]);
        break;

      case 'skills':
        _addOutput([
          'TECHNICAL SKILLS (From Resume):',
          '• Languages: C++, Python, SQL, Java, Dart, Bash, C, JavaScript',
          '• Cloud & DevOps: Docker, Linux, GCP, Terraform, Jenkins, Ansible, CI/CD, Nginx',
          '• Backend: Node.js, Express.js, Flask, REST APIs, MongoDB',
          '• Mobile Development: Flutter, Supabase, Firebase, CI/CD, GetX, Hive DB',
        ]);
        break;

      case 'leadership':
        _addOutput([
          'LEADERSHIP EXPERIENCE:',
          'FinDrome:',
          '• Managing Director:',
          '  - Orchestrated large-scale college fests, directing 100+ student workforce.',
          '  - Built inter-departmental operational frameworks bridging technical & event teams.',
          '• Tech Head & Event Head:',
          '  - Directed complete project lifecycle of technical initiatives to milestones.',
          '  - Mentored 6-member engineering team & handled operations for 200+ attendees.',
        ]);
        break;

      case 'research':
        _addOutput([
          'ACADEMIC RESEARCH & PUBLICATIONS:',
          '• Springer Research Co-Author (FICTA 2025)',
          '• Co-authored paper accepted for FICTA 2025 conference proceedings.',
          '• Research focus on cloud-native systems, DevOps automation, and computational engineering.',
        ]);
        break;

      case 'education':
        _addOutput([
          'EDUCATION:',
          '1. Mukesh Patel School of Technology Management and Engineering, Mumbai',
          '   • B.Tech in Computer Engineering (Expected Graduation: 2028)',
          '2. Rustomjee International School, Mumbai',
          '   • Secondary School Certificate (SSC) (Graduated: 2022)',
        ]);
        break;

      case 'contact':
        _addOutput([
          'CONTACT INFORMATION:',
          '• Email: surasaumya17@gmail.com',
          '• GitHub: https://github.com/Saumya-sura',
          '• LinkedIn: https://www.linkedin.com/in/saumya-sura-a73734270/',
          '• Location: Mumbai, India',
        ]);
        break;

      case 'hire':
        _addOutput([
          '🚀 STATUS: OPEN FOR INTERNSHIPS & OPPORTUNITIES',
          '• Experienced in Flutter, Cloud Infrastructure, and CI/CD.',
          '• Launching email client to surasaumya17@gmail.com ...',
        ]);
        launchUrl(Uri.parse('mailto:surasaumya17@gmail.com'));
        break;

      case 'matrix':
        setState(() {
          _matrixMode = !_matrixMode;
        });
        _addOutput([
          _matrixMode
              ? '🟢 Matrix Digital Rain: ACTIVATED'
              : '⚪ Matrix Digital Rain: DEACTIVATED',
        ]);
        break;

      case 'sudo':
        _addOutput([
          '[!] Saumya Sura is the authenticated superuser with full root access.',
        ]);
        break;

      case 'clear':
        setState(() {
          _history.clear();
        });
        break;

      default:
        _addOutput([
          "zsh: command not found: $cmd. Type 'help' for list of valid commands.",
        ]);
    }

    _scrollToBottom();
  }

  void _addOutput(List<String> lines) {
    for (var line in lines) {
      _history.add({'type': 'output', 'text': line});
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<ColorProvider>().color;

    return Scaffold(
      backgroundColor: const Color(0xFF090D12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131A22),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFF5F56), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFFFBD2E), shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF27C93F), shape: BoxShape.circle)),
            const SizedBox(width: 12),
            Text(
              "saumya@terminal:~",
              style: GoogleFonts.firaCode(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _matrixMode ? Icons.grain_rounded : Icons.water_drop_outlined,
              color: _matrixMode ? Colors.greenAccent : Colors.white60,
              size: 20,
            ),
            tooltip: "Toggle Matrix Rain",
            onPressed: () {
              _handleCommand('matrix');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_matrixMode) const MatrixRainBackground(),

          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(14.0),
                  itemCount: _history.length,
                  itemBuilder: (context, index) {
                    final item = _history[index];
                    final String text = item['text'];
                    final String type = item['type'];

                    Color textColor = Colors.greenAccent.shade400;
                    if (type == 'input') {
                      textColor = Colors.cyanAccent;
                    } else if (type == 'system') {
                      textColor = Colors.amberAccent.shade200;
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: SelectableText(
                        text,
                        style: GoogleFonts.firaCode(
                          color: textColor,
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: type == 'input' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Quick Action Chips
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickCommands.length,
                  itemBuilder: (context, index) {
                    final cmd = _quickCommands[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: ActionChip(
                        label: Text(
                          cmd,
                          style: GoogleFonts.firaCode(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: const Color(0xFF1B2430),
                        side: BorderSide(
                          color: themeColor.withOpacity(0.4),
                          width: 1,
                        ),
                        onPressed: () {
                          SoundService().playClick();
                          _handleCommand(cmd);
                        },
                      ),
                    );
                  },
                ),
              ),

              // Command Input Bar
              Container(
                color: const Color(0xFF131A22),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "❯ ",
                      style: GoogleFonts.firaCode(
                        color: themeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        focusNode: _focusNode,
                        style: GoogleFonts.firaCode(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        cursorColor: Colors.greenAccent,
                        decoration: InputDecoration(
                          hintText: _isBooting ? "Booting..." : "type command (e.g. 'help')...",
                          hintStyle: GoogleFonts.firaCode(
                            color: Colors.white30,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (_) {
                          SoundService().playKey();
                        },
                        onSubmitted: (value) {
                          _handleCommand(value);
                          _focusNode.requestFocus();
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.greenAccent, size: 18),
                      onPressed: () {
                        _handleCommand(_inputController.text);
                        _focusNode.requestFocus();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MatrixRainBackground extends StatefulWidget {
  const MatrixRainBackground({super.key});

  @override
  State<MatrixRainBackground> createState() => _MatrixRainBackgroundState();
}

class _MatrixRainBackgroundState extends State<MatrixRainBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final List<MatrixColumn> _columns = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    for (int i = 0; i < 22; i++) {
      _columns.add(MatrixColumn(
        xRatio: i / 22.0,
        speed: 1.5 + _random.nextDouble() * 2.5,
        length: 8 + _random.nextInt(12),
        yOffset: _random.nextDouble() * 600,
      ));
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: MatrixPainter(_columns),
        );
      },
    );
  }
}

class MatrixColumn {
  final double xRatio;
  final double speed;
  final int length;
  double yOffset;

  MatrixColumn({
    required this.xRatio,
    required this.speed,
    required this.length,
    required this.yOffset,
  });
}

class MatrixPainter extends CustomPainter {
  final List<MatrixColumn> columns;
  final String characters = '0123456789ABCDEF<>/*&^#@';

  MatrixPainter(this.columns);

  @override
  void paint(Canvas canvas, Size size) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var col in columns) {
      col.yOffset += col.speed;
      if (col.yOffset > size.height + 150) {
        col.yOffset = -100;
      }

      final x = col.xRatio * size.width;

      for (int i = 0; i < col.length; i++) {
        final y = col.yOffset - (i * 16);
        if (y < 0 || y > size.height) continue;

        final opacity = (1.0 - (i / col.length)).clamp(0.1, 0.9);
        final char = characters[(x.toInt() + i * 3) % characters.length];

        textPainter.text = TextSpan(
          text: char,
          style: TextStyle(
            color: i == 0
                ? Colors.white.withOpacity(0.9)
                : Colors.greenAccent.withOpacity(opacity * 0.4),
            fontSize: 12,
            fontFamily: 'monospace',
            fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
          ),
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
