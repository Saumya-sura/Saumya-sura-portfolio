import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart' show usePathUrlStrategy;
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio_website/presentation/mobile_screens/mobile_home_page.dart';
import 'package:provider/provider.dart';
import 'presentation/home_page.dart';
import 'providers/color_provider.dart';
import 'providers/phone_state_provider.dart';

void main() {
  usePathUrlStrategy();
  runApp(const RootApp());
}
class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PhoneStateProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Saumya Sura | Portfolio',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB),
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.rubikTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/mobile': (context) => const MobileHomePage(),
        },
      ),
    );
  }
}
