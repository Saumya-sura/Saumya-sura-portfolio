import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/color_provider.dart';
import '../../../providers/phone_state_provider.dart';

class PhoneStatusBar extends StatefulWidget {
  final bool isDarkBackground;

  const PhoneStatusBar({
    super.key,
    this.isDarkBackground = true,
  });

  @override
  State<PhoneStatusBar> createState() => _PhoneStatusBarState();
}

class _PhoneStatusBarState extends State<PhoneStatusBar> {
  late Timer _clockTimer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  String get _timeString {
    final hour = _currentTime.hour.toString().padLeft(2, '0');
    final minute = _currentTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final phoneState = context.watch<PhoneStateProvider>();
    final isExpanded = phoneState.isExpanded;
    final notification = phoneState.currentNotification;
    final themeColor = context.watch<ColorProvider>().color;

    final Color statusTextColor = widget.isDarkBackground ? Colors.white : Colors.black;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Top status bar bar items (Time, Wi-Fi, Battery)
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: Live Clock
              Text(
                _timeString,
                style: TextStyle(
                  color: statusTextColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),

              // Spacer for Dynamic Island in center
              const SizedBox(width: 120),

              // Right: Signal, WiFi, Battery
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.signal_cellular_alt_rounded,
                    size: 15,
                    color: statusTextColor,
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.wifi_rounded,
                    size: 15,
                    color: statusTextColor,
                  ),
                  const SizedBox(width: 6),
                  // Battery Pill
                  _buildBatteryPill(statusTextColor),
                ],
              ),
            ],
          ),
        ),

        // Centered Interactive Dynamic Island
        Positioned(
          top: 4,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                phoneState.toggleIsland();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                width: isExpanded ? 310 : 120,
                height: isExpanded ? 64 : 28,
                padding: EdgeInsets.symmetric(
                  horizontal: isExpanded ? 14 : 10,
                  vertical: isExpanded ? 8 : 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(isExpanded ? 24 : 16),
                  border: Border.all(
                    color: isExpanded
                        ? themeColor.withOpacity(0.5)
                        : Colors.white.withOpacity(0.12),
                    width: isExpanded ? 1.5 : 0.8,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: isExpanded ? 14 : 6,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: isExpanded
                          ? themeColor.withOpacity(0.25)
                          : Colors.transparent,
                      blurRadius: isExpanded ? 18 : 0,
                      spreadRadius: isExpanded ? 1 : 0,
                    ),
                  ],
                ),
                child: isExpanded
                    ? _buildExpandedIsland(notification, phoneState, themeColor)
                    : _buildCompactIsland(themeColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBatteryPill(Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '98%',
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 3),
        Container(
          width: 22,
          height: 11,
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.5),
            border: Border.all(color: textColor, width: 1.2),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.greenAccent.shade400,
              borderRadius: BorderRadius.circular(1.5),
            ),
          ),
        ),
        Container(
          width: 1.5,
          height: 4,
          decoration: BoxDecoration(
            color: textColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(1),
              bottomRight: Radius.circular(1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactIsland(Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left camera/mic sensor dot
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            shape: BoxShape.circle,
          ),
        ),
        // Center subtle pulse indicator
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.8),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Text(
              "OS 2.6",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        // Right camera lens
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            color: Color(0xFF141416),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedIsland(
    IslandNotification? notif,
    PhoneStateProvider provider,
    Color themeColor,
  ) {
    final title = notif?.title ?? 'Notification';
    final subtitle = notif?.subtitle ?? 'All systems active';
    final icon = notif?.icon ?? Icons.notifications_active_rounded;
    final iconColor = notif?.iconColor ?? themeColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon with glowing circle
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.18),
            shape: BoxShape.circle,
            border: Border.all(
              color: iconColor.withOpacity(0.6),
              width: 1.2,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 10),

        // Text details
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        // Dismiss action button
        GestureDetector(
          onTap: () => provider.collapseIsland(),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    );
  }
}
