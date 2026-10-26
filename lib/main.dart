import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'progress_store.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(KalimatiApp(store: ProgressStore(prefs)));
}

class KalimatiApp extends StatelessWidget {
  final ProgressStore store;
  const KalimatiApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return ProgressScope(
      store: store,
      child: MaterialApp(
        title: 'كلمتي',
        debugShowCheckedModeBanner: false,
        locale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00897B)),
          // TODO: add a rounded Arabic font (e.g. Cairo) under assets/fonts.
        ),
        home: store.onboardingDone ? const HomeScreen() : const OnboardingScreen(),
      ),
    );
  }
}
