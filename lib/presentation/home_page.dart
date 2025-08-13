import 'package:device_frame/device_frame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:starsview/config/StarsConfig.dart';
import 'package:starsview/starsview.dart';

import '../providers/color_provider.dart';
import 'components/about_me.dart';
import 'components/blurred_background_container.dart';
import 'components/blurred_background_popup.dart';
import 'components/color_picker.dart';
import 'mobile_screens/mobile_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSmallScreen = false;
  // Device switcher state
  DeviceType _selectedDevice = DeviceType.iphone;

  // Enum for device types
  // Removed unused static constants

  // DeviceType enum
  // (Add this above _HomePageState if not present)
  // enum DeviceType { iphone, tablet }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      MediaQuery.of(context).size.width < 1024
          ? isSmallScreen = true
          : isSmallScreen = false;
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 24),
                // Device Switcher Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDeviceIcon(
                      icon: Icons.phone_iphone,
                      label: 'iPhone',
                      selected: _selectedDevice == DeviceType.iphone,
                      onTap: () => setState(() => _selectedDevice = DeviceType.iphone),
                    ),
                    SizedBox(width: 24),
                    _buildDeviceIcon(
                      icon: Icons.android,
                      label: 'Android',
                      selected: _selectedDevice == DeviceType.android,
                      onTap: () => setState(() => _selectedDevice = DeviceType.android),
                    ),
                    SizedBox(width: 24),
                    _buildDeviceIcon(
                      icon: Icons.tablet,
                      label: 'Tablet',
                      selected: _selectedDevice == DeviceType.tablet,
                      onTap: () => setState(() => _selectedDevice = DeviceType.tablet),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Main content row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                padding: const EdgeInsets.all(8.0),
                child: !isSmallScreen
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const BlurredBackgroundContainer(
                          child: AboutMe(),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.05,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.blue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const BlurredBackgroundPopup(
                                    child: AboutMe(
                                      isPopup: true,
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.person,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
                  ),
                  Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                    maxHeight: MediaQuery.of(context).size.height * 0.95,
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
                            ChangeNotifierProvider<ColorProvider>(
                              create: (deviceContext) => ColorProvider(
                                color: context.watch<ColorProvider>().color,
                              ),
                            ),
                          ],
                          child: MaterialApp(
                            title: 'Saumya sura',
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
                  Padding(
                padding: const EdgeInsets.all(8.0),
                child: !isSmallScreen
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: const BlurredBackgroundContainer(
                          child: ColorPicker(),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.05,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: const LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.blue,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return const BlurredBackgroundPopup(
                                    child: ColorPicker(
                                      isPopup: true,
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.color_lens,
                              size: 12,
                            ),
                          ),
                        ),
                      ),
              ),
                ], // end Row children
              ), // end Row
            ], // end Column children
          ), 
          )// end SingleChildScrollView
        ], // end Stack children
      ), // end Stack
    ); // end Scaffold
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
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    colors: [Colors.blueAccent, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selected ? null : Colors.grey.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            boxShadow: selected
                ? [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 8, offset: Offset(0, 2))]
                : [],
            border: Border.all(
              color: selected ? Colors.blue : Colors.transparent,
              width: 2,
            ),
          ),
          child: AnimatedScale(
            scale: selected ? 1.15 : 1.0,
            duration: Duration(milliseconds: 200),
            child: Icon(
              icon,
              color: selected ? Colors.white : Colors.grey,
              size: 36,
            ),
          ),
        ),
        SizedBox(height: 6),
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
