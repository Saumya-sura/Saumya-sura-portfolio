import 'dart:async';
import 'package:flutter/material.dart';

class IslandNotification {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  IslandNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    this.icon = Icons.notifications_active_rounded,
    this.iconColor = Colors.greenAccent,
    this.onTap,
  });
}

class PhoneStateProvider extends ChangeNotifier {
  IslandNotification? _currentNotification;
  bool _isExpanded = false;
  Timer? _dismissTimer;
  Timer? _periodicTimer;
  int _periodicIndex = 0;

  IslandNotification? get currentNotification => _currentNotification;
  bool get isExpanded => _isExpanded;

  final List<IslandNotification> _cannedNotifications = [
    IslandNotification(
      id: 'recruiter',
      title: 'Recruiter Alert 💬',
      subtitle: 'Open for Summer & Winter Internships!',
      icon: Icons.work_outline_rounded,
      iconColor: Colors.amberAccent,
    ),
    IslandNotification(
      id: 'ontrack',
      title: 'MPSTME OnTrack 🚀',
      subtitle: '1,400+ downloads on App Store & Play Store',
      icon: Icons.rocket_launch_rounded,
      iconColor: Colors.blueAccent,
    ),
    IslandNotification(
      id: 'terminal',
      title: 'New App Added ⚡',
      subtitle: 'Check out the interactive Matrix Terminal!',
      icon: Icons.terminal_rounded,
      iconColor: Colors.greenAccent,
    ),
    IslandNotification(
      id: 'skills',
      title: 'Tech Stack 🛠️',
      subtitle: 'Flutter • Dart • Firebase • Python • AI/ML',
      icon: Icons.star_rounded,
      iconColor: Colors.purpleAccent,
    ),
  ];

  PhoneStateProvider() {
    _startPeriodicNotifications();
  }

  void _startPeriodicNotifications() {
    // Show first friendly welcome notification after 3 seconds
    Timer(const Duration(seconds: 3), () {
      triggerNotification(
        title: 'Welcome to my Portfolio! 👋',
        subtitle: 'Tap apps or change theme colors anytime',
        icon: Icons.waving_hand_rounded,
        iconColor: Colors.amberAccent,
        duration: const Duration(seconds: 5),
      );
    });

    // Send periodic updates every 30 seconds
    _periodicTimer = Timer.periodic(const Duration(seconds: 35), (timer) {
      if (_currentNotification == null && !_isExpanded) {
        final notif = _cannedNotifications[_periodicIndex % _cannedNotifications.length];
        _periodicIndex++;
        triggerNotification(
          title: notif.title,
          subtitle: notif.subtitle,
          icon: notif.icon,
          iconColor: notif.iconColor,
          duration: const Duration(seconds: 5),
        );
      }
    });
  }

  void triggerNotification({
    required String title,
    required String subtitle,
    IconData icon = Icons.notifications_active_rounded,
    Color iconColor = Colors.greenAccent,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    _dismissTimer?.cancel();
    _currentNotification = IslandNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
    );
    _isExpanded = true;
    notifyListeners();

    _dismissTimer = Timer(duration, () {
      collapseIsland();
    });
  }

  void toggleIsland() {
    if (_isExpanded) {
      collapseIsland();
    } else {
      expandIsland();
    }
  }

  void expandIsland() {
    _isExpanded = true;
    _currentNotification ??= IslandNotification(
      id: 'system',
      title: 'Saumya-OS v2.6 ⚡',
      subtitle: 'Dynamic Island active • All systems optimal',
      icon: Icons.info_outline_rounded,
      iconColor: Colors.cyanAccent,
    );
    notifyListeners();
  }

  void collapseIsland() {
    _isExpanded = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }
}
