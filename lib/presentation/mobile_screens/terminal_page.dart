import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/color_provider.dart';
import '../../providers/phone_state_provider.dart';

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
    'projects',
    'skills',
    'hire',
    'matrix',
    'contact',
    'clear',
  ];

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  void _startBootSequence() async {
    final bootLines = [
      '[OK] Initializing SAUMYA-OS v2.6.4 (arm64) ...',
      '[OK] Loading Flutter Engine & CanvasKit ...',
      '[OK] Mounting /home/saumya/projects ...',
      '───────────────────────────────────────────────',
      'SAUMYA SURA • Interactive Terminal v2.6',
      "Type 'help' or tap the command chips below.",
      '───────────────────────────────────────────────',
    ];

    for (var line in bootLines) {
      await Future.delayed(const Duration(milliseconds: 180));
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

      // Announce via Dynamic Island
      try {
        context.read<PhoneStateProvider>().triggerNotification(
              title: 'Terminal Active 💻',
              subtitle: "Try typing 'hire' or 'matrix'!",
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

    setState(() {
      _history.add({'type': 'input', 'text': 'saumya@portfolio:~\$ $rawCommand'});
    });

    switch (cmd) {
      case 'help':
        _addOutput([
          'AVAILABLE COMMANDS:',
          '  about     - Learn about Saumya Sura & background',
          '  projects  - List flagship mobile & web projects',
          '  skills    - Display technical skills & proficiencies',
          '  education - Details on B.Tech at NMIMS MPSTME',
          '  contact   - Get email, GitHub, and social links',
          '  hire      - Internship availability & direct hire action',
          '  matrix    - Toggle cyberpunk digital rain stream',
          '  clear     - Clear the terminal screen',
          '  sudo      - Execute command as superuser',
        ]);
        break;

      case 'about':
        _addOutput([
          'SAUMYA SURA',
          '• B.Tech Computer Engineering Student @ NMIMS MPSTME, Mumbai',
          '• Passionate Flutter, Mobile, and Web Developer',
          '• Creator of MPSTME OnTrack with 1,400+ downloads',
          '• Enjoys UI/UX design, AI integration, and competitive chess ♟️',
        ]);
        break;

      case 'projects':
        _addOutput([
          'FLAGSHIP PROJECTS:',
          '1. MPSTME OnTrack 📱',
          '   • Schedule & timetable tracking for university students.',
          '   • 1,400+ downloads across Apple App Store & Google Play Store.',
          '2. TOT App 🐾',
          '   • Pet care app with Hive local DB, Firebase, and OpenAI API.',
          '3. WellVerse 🧘',
          '   • Meditation & wellness tracking with offline SQLite storage.',
          '4. Fitness AI 🏋️',
          '   • Gemini AI-powered meal recommendations & fitness tracker.',
        ]);
        break;

      case 'skills':
        _addOutput([
          'TECH ARSENAL:',
          '• Mobile: Flutter, Dart, Kotlin, Android Studio',
          '• Web & Backend: Node.js, Express.js, JavaScript, Python',
          '• Databases: Firebase, Supabase, Hive, SQLite, MongoDB',
          '• Tools: Git, GitHub Actions, Postman, Docker, Figma, VSCode',
        ]);
        break;

      case 'education':
        _addOutput([
          'EDUCATION HISTORY:',
          '• B.Tech in Computer Engineering (2022 - 2028)',
          '  Mukesh Patel School of Technology Management and Engineering',
          '• Secondary School Certificate (2010 - 2022)',
          '  Rustomjee International School, Mumbai',
        ]);
        break;

      case 'contact':
        _addOutput([
          'DIRECT CONTACT:',
          '• Email: surasaumya17@protonmail.com',
          '• GitHub: github.com/Saumya-sura',
          '• LinkedIn: linkedin.com/in/saumya-sura-a73734270',
        ]);
        break;

      case 'hire':
        _addOutput([
          '🚀 INTERNSHIP STATUS: READY TO CONTRIBUTE',
          '• Saumya is actively open for Software Engineering & Mobile Internships.',
          '• Fast learner, self-directed, experienced in production apps.',
          'Opening email client...',
        ]);
        launchUrl(Uri.parse('mailto:surasaumya17@protonmail.com'));
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
          '[!] Access denied: Saumya Sura is the only authorized superuser here 😉',
        ]);
        break;

      case 'clear':
        setState(() {
          _history.clear();
        });
        break;

      default:
        _addOutput([
          "zsh: command not found: $cmd. Type 'help' for valid commands.",
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
          duration: const Duration(milliseconds: 250),
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
            // Window controls
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
          // Optional Animated Matrix Rain Canvas
          if (_matrixMode) const MatrixRainBackground(),

          Column(
            children: [
              // Scrollable Output List
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
                          fontSize: 13,
                          height: 1.4,
                          fontWeight: type == 'input' ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Quick Action Command Chips
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
                        onPressed: () => _handleCommand(cmd),
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
                          fontSize: 14,
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

// Matrix Digital Rain background animation
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
