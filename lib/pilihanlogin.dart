// ==========================================
// HALAMAN PILIHAN LOGIN (AUTH GATEWAY)
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'login.dart';
import 'register.dart';

class AuthGatewayPage extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;
  final String appLanguage;
  final Function(String) onLanguageChanged;

  // GoogleSignIn instance
  const AuthGatewayPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.appLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<AuthGatewayPage> createState() => _AuthGatewayPageState();
}

class _AuthGatewayPageState extends State<AuthGatewayPage> {
  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005ab7);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDQCSAmnSLApaogjXG4tPKf-Epj0ODd2QOJOa1DEdQ4OEVaWSALSVwsoAiJpqFrgfZTfuyaBIMcxMBdB4onvHaJzb0TVPcfsGig7U0VFFkhZQ2elDxNxX5UnBbmnWsT0S_dEijjbEZZqp12f4hBO2f5ftTQskfVl-3WwBNRd43OiuriMLvAgspSIWs1Bn8m5ejULA8rWfeRxO08nza7GrrOCwrhfLdM3J9dkPn7jnAr-LnbmueI1Ci2dK_4hNdqAzDOkIl339MEpps',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),
          // Main Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo
                                Image.asset(
                                  'assets/logo.jpg',
                                  height: 80,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 40),
                                // Branding
                                const Text(
                                  'TravelEase',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Mulai petualangan tak terlupakan Anda hari ini. Jelajahi dunia dengan kemudahan dalam genggaman.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF414754),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Auth Buttons
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                            onThemeChanged:
                                                widget.onThemeChanged,
                                            themeMode: widget.themeMode,
                                            appLanguage: widget.appLanguage,
                                            onLanguageChanged:
                                                widget.onLanguageChanged,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      elevation: 4,
                                      shadowColor: primaryColor.withOpacity(
                                        0.25,
                                      ),
                                    ),
                                    child: const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => RegisterPage(
                                            onThemeChanged:
                                                widget.onThemeChanged,
                                            themeMode: widget.themeMode,
                                            appLanguage: widget.appLanguage,
                                            onLanguageChanged:
                                                widget.onLanguageChanged,
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: primaryColor,
                                      side: const BorderSide(
                                        color: primaryColor,
                                        width: 2,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      'Daftar',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text.rich(
                          TextSpan(
                            text: 'Dengan melanjutkan, Anda menyetujui\n',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(
                                text: 'Ketentuan Layanan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFabc7ff),
                                ),
                              ),
                              TextSpan(text: ' & '),
                              TextSpan(
                                text: 'Kebijakan Privasi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFabc7ff),
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
}
