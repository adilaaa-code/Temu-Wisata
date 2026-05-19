// --- HALAMAN ONBOARDING (KONVERSI DARI HTML) ---
import 'package:flutter/material.dart';
import 'dart:ui';
import 'main.dart'; // Import main.dart untuk mengakses MainAuthWrapper

class OnboardingPage extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;
  final String appLanguage;
  final Function(String) onLanguageChanged;

  const OnboardingPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.appLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageController;
  double _pageOffset = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController.page ?? 0;
        });
      });
  }

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Jelajahi Indonesia",
      "description":
          "Temukan keindahan tersembunyi dari Sabang sampai Merauke dalam genggamanmu.",
      "image":
          "https://images.unsplash.com/photo-1505993597083-3bd19fb75e57?q=80&w=1000",
      "icon": "🚀",
    },
    {
      "title": "Pelajari Budaya",
      "description":
          "Kenali lebih dalam warisan leluhur dan sejarah megah di setiap sudut nusantara.",
      "image":
          "https://images.unsplash.com/photo-1596306499317-8490232098fa?q=80&w=1000",
      "icon": "🏺",
    },
    {
      "title": "Uji Pengetahuanmu",
      "description":
          "Selesaikan kuis interaktif, kumpulkan XP, dan jadilah penjelajah sejati!",
      "image":
          "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?q=80&w=1000",
      "icon": "🏆",
    },
  ];

  void _onFinished() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MainAuthWrapper(
          themeMode: widget.themeMode,
          onThemeChanged: widget.onThemeChanged,
          appLanguage: widget.appLanguage,
          onLanguageChanged: widget.onLanguageChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_onboardingData[index]['image']!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _onboardingData[index]['icon']!,
                          style: const TextStyle(fontSize: 50),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _onboardingData[index]['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _onboardingData[index]['description']!,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 120), // Space for dots/buttons
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // UI Elements (Skip, Dots, Next)
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _onFinished,
              child: const Text(
                "Lewati",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),

          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dots Indicator
                Row(
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 6,
                      width: _currentPage == index ? 32 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ),

                // Next/Start Button
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentPage == _onboardingData.length - 1 ? 180 : 100,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingData.length - 1) {
                        _onFinished();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutQuart,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF005ab7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _currentPage == _onboardingData.length - 1
                            ? "Mulai Jelajah"
                            : "Lanjut",
                        key: ValueKey(_currentPage),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
