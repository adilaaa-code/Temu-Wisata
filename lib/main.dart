import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart'; // File ini dihasilkan otomatis oleh FlutterFire CLI
import 'login.dart';
import 'main_navigation_wrapper.dart';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inisialisasi Firebase dengan opsi otomatis dari FlutterFire CLI
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  String _appLanguage = 'English US';

  void _onThemeChanged(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _appLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temu Wisata',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005ab7),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005ab7),
          brightness: Brightness.dark,
        ),
      ),
      home: SplashScreen(
        themeMode: _themeMode,
        onThemeChanged: _onThemeChanged,
        appLanguage: _appLanguage,
        onLanguageChanged: _onLanguageChanged,
      ),
    );
  }
}

/// Widget untuk menangani status autentikasi setelah Splash & Onboarding selesai
class MainAuthWrapper extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;
  final String appLanguage;
  final Function(String) onLanguageChanged;

  const MainAuthWrapper({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.appLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Menggunakan AnimatedSwitcher untuk transisi yang halus antara Login dan Home
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: snapshot.hasData
              ? MainNavigationWrapper(
                  key: const ValueKey('Home'),
                  themeMode: themeMode,
                  onThemeChanged: onThemeChanged,
                  appLanguage: appLanguage,
                  onLanguageChanged: onLanguageChanged,
                )
              : LoginPage(
                  key: const ValueKey('Login'),
                  themeMode: themeMode,
                  onThemeChanged: onThemeChanged,
                  appLanguage: appLanguage,
                  onLanguageChanged: onLanguageChanged,
                ),
        );
      },
    );
  }
}
