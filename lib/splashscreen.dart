// --- HALAMAN SPLASH SCREEN (LOGO POP-UP DARI TENGAH) ---
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import 'onboarding.dart'; // Pastikan import ini benar

class SplashScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;
  final String appLanguage;
  final Function(String) onLanguageChanged;

  const SplashScreen({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.appLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoScale;

  bool _isBgExpanded = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    // 1. Controller untuk animasi skala logo (Pop-up)
    _logoController = AnimationController(
      vsync: this,
      // Durasi kemunculan logo dibuat lebih cepat untuk efek pop-up
      duration: const Duration(milliseconds: 600),
    );

    // Perbaikan: Gunakan easeOutBack (Curves.backOut tidak ada di Flutter)
    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    _startAnimation();
  }

  void _startAnimation() async {
    // Langkah 1: Tunggu sebentar di awal (layar putih)
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    // Langkah 2: Munculkan logo dengan efek pop-up skala
    _logoController.forward();

    // Langkah 3: Perluas background biru secara smooth
    // Delay sedikit agar logo muncul duluan sebelum background menyapu layar
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() {
      _isBgExpanded = true;
    });

    // Langkah 4: Munculkan teks setelah background dan logo stabil
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _showText = true;
    });

    // Langkah 5: Pindah ke halaman Onboarding
    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OnboardingPage(
                themeMode: widget.themeMode,
                onThemeChanged: widget.onThemeChanged,
                appLanguage: widget.appLanguage,
                onLanguageChanged: widget.onLanguageChanged,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Transisi memudar (Fade) agar perpindahan ke onboarding lebih elegan
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mendapatkan ukuran layar untuk ekspansi background
    final screenSize = MediaQuery.of(context).size;
    final maxRadius = screenSize.height > screenSize.width
        ? screenSize.height
        : screenSize.width;

    return Scaffold(
      backgroundColor: Colors.white, // Warna dasar awal
      body: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Efek Lingkaran Biru yang Membesar Smooth
          AnimatedContainer(
            duration: const Duration(
              milliseconds: 1200,
            ), // Durasi lebih lama agar smooth
            curve: Curves
                .easeInOutQuart, // Kurva yang sangat halus (percepatan & perlambatan)
            width: _isBgExpanded ? maxRadius * 2 : 0,
            height: _isBgExpanded ? maxRadius * 2 : 0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF005ab7), // Biru Utama (Dari kode Anda)
                  Color(0xFF002d5b), // Biru Gelap (Dari kode Anda)
                ],
              ),
            ),
          ),

          // 2. Konten Tengah (Pop-up Logo + Teks) dibungkus Center & mainAxisSize.min
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Mengunci konten di tengah
              children: [
                // ScaleTransition sekarang diatur agar membesar tepat dari titik tengah
                ScaleTransition(
                  scale: _logoScale,
                  alignment: Alignment.center,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/app_logo.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // 3. Teks Nama Aplikasi (Fade-in)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _showText ? 1.0 : 0.0,
                  child: const Text(
                    "TEMU WISATA",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
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
