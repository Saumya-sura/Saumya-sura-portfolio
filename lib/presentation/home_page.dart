import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:starsview/config/StarsConfig.dart';
import 'package:starsview/starsview.dart';

import '../providers/color_provider.dart';
import '../providers/phone_state_provider.dart';
import '../services/sound_service.dart';
import 'components/about_me.dart';
import 'components/blurred_background_container.dart';
import 'components/blurred_background_popup.dart';
import 'components/color_picker.dart';
import 'mobile_screens/components/resume_modal.dart';
import 'mobile_screens/mobile_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Device switcher state
  DeviceType _selectedDevice = DeviceType.iphone;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isSmallScreen = screenWidth < 1024;
    final bool isMobileScreen = screenWidth < 600;

    double frameMaxWidth;
    if (_selectedDevice == DeviceType.tablet) {
      frameMaxWidth = isSmallScreen ? (screenWidth * 0.92).clamp(280.0, 680.0) : 680.0;
    } else if (_selectedDevice == DeviceType.android) {
      frameMaxWidth = isSmallScreen ? (screenWidth * 0.90).clamp(280.0, 410.0) : 410.0;
    } else {
      frameMaxWidth = isSmallScreen ? (screenWidth * 0.90).clamp(280.0, 425.0) : 425.0;
    }

    return Scaffold(
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.watch<ColorProvider>().color.withOpacity(0.5),
                  context.watch<ColorProvider>().color.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const StarsView(
            fps: 60,
            starsConfig: StarsConfig(
              starCount: 250,
              maxStarSize: 5,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Device Switcher & Quick Action Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDeviceIcon(
                        icon: Icons.phone_iphone,
                        label: 'iPhone',
                        selected: _selectedDevice == DeviceType.iphone,
                        onTap: () {
                          SoundService().playClick();
                          setState(() => _selectedDevice = DeviceType.iphone);
                        },
                      ),
                      const SizedBox(width: 14),
                      _buildDeviceIcon(
                        icon: Icons.android,
                        label: 'Android',
                        selected: _selectedDevice == DeviceType.android,
                        onTap: () {
                          SoundService().playClick();
                          setState(() => _selectedDevice = DeviceType.android);
                        },
                      ),
                      const SizedBox(width: 14),
                      _buildDeviceIcon(
                        icon: Icons.tablet,
                        label: 'Tablet',
                        selected: _selectedDevice == DeviceType.tablet,
                        onTap: () {
                          SoundService().playClick();
                          setState(() => _selectedDevice = DeviceType.tablet);
                        },
                      ),
                      const SizedBox(width: 18),
                      // Quick PDF Resume Action
                      _buildActionButton(
                        icon: Icons.picture_as_pdf_rounded,
                        label: 'Resume PDF',
                        accentColor: Colors.amberAccent,
                        onTap: () {
                          SoundService().playPop();
                          ResumeModal.show(context);
                        },
                      ),
                      const SizedBox(width: 14),
                      // Sound Toggle
                      _buildActionButton(
                        icon: SoundService().isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
                        label: SoundService().isMuted ? 'Muted' : 'Audio ON',
                        accentColor: Colors.cyanAccent,
                        onTap: () {
                          SoundService().toggleMute();
                          setState(() {});
                        },
                      ),
                      if (isSmallScreen) ...[
                        const SizedBox(width: 14),
                        // About Me popup on small screen
                        _buildActionButton(
                          icon: Icons.person_rounded,
                          label: 'About Me',
                          accentColor: Colors.pinkAccent,
                          onTap: () {
                            SoundService().playClick();
                            showDialog(
                              context: context,
                              builder: (context) => const BlurredBackgroundPopup(
                                child: AboutMe(isPopup: true),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 14),
                        // Theme color popup on small screen
                        _buildActionButton(
                          icon: Icons.color_lens_rounded,
                          label: 'Theme',
                          accentColor: context.watch<ColorProvider>().color,
                          onTap: () {
                            SoundService().playClick();
                            showDialog(
                              context: context,
                              builder: (context) => const BlurredBackgroundPopup(
                                child: ColorPicker(isPopup: true),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Main content row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSmallScreen)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const BlurredBackgroundContainer(
                            child: AboutMe(),
                          ),
                        ),
                      ),
                    Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: frameMaxWidth,
                          maxHeight: isMobileScreen
                              ? (screenHeight * 0.84).clamp(500.0, 850.0)
                              : (screenHeight * 0.90).clamp(600.0, 920.0),
                        ),
                        child: DeviceFrame(
                          isFrameVisible: true,
                          device: _selectedDevice == DeviceType.iphone
                              ? Devices.ios.iPhone13ProMax
                              : _selectedDevice == DeviceType.android
                                  ? Devices.android.samsungGalaxyA50
                                  : Devices.ios.iPad,
                          screen: Builder(
                            builder: (BuildContext deviceContext) {
                              return MultiProvider(
                                providers: [
                                  ChangeNotifierProvider<ColorProvider>.value(
                                    value: context.watch<ColorProvider>(),
                                  ),
                                  ChangeNotifierProvider<PhoneStateProvider>.value(
                                    value: context.watch<PhoneStateProvider>(),
                                  ),
                                ],
                                child: MaterialApp(
                                  title: 'Saumya Sura',
                                  theme: ThemeData(
                                    colorScheme: ColorScheme.fromSeed(
                                      seedColor: context.watch<ColorProvider>().color,
                                      brightness: Brightness.dark,
                                    ),
                                    useMaterial3: true,
                                    textTheme: GoogleFonts.rubikTextTheme(),
                                  ),
                                  debugShowCheckedModeBanner: false,
                                  home: MobileHomePage(
                                    color: context.watch<ColorProvider>().color,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    if (!isSmallScreen)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: const BlurredBackgroundContainer(
                            child: ColorPicker(),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: accentColor.withOpacity(0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 34,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceIcon({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: selected
                  ? const LinearGradient(
                      colors: [Colors.blueAccent, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: selected ? null : Colors.grey.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
              border: Border.all(
                color: selected ? Colors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: AnimatedScale(
              scale: selected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: selected ? Colors.white : Colors.grey,
                size: 36,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.blue : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// Add this enum above _HomePageState if not present
enum DeviceType { iphone, android, tablet }
