import 'package:flutter/material.dart';
import 'dart:ui';

// Helper function to get ImageProvider from asset or network
ImageProvider getImageProvider(String? imageUrl) {
  if (imageUrl == null || imageUrl.isEmpty) {
    // Fallback to a default asset or just let errorBuilder handle it
    return const AssetImage(
      'assets/app_logo.png',
    ); // Using app_logo as a generic fallback
  }
  if (imageUrl.startsWith('assets/')) {
    return AssetImage(imageUrl);
  } else {
    return NetworkImage(imageUrl);
  }
}

PreferredSizeWidget buildBlurredAppBar(
  BuildContext context,
  String title, {
  bool showProfile = false,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(64),
    child: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: AppBar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.surface.withOpacity(0.8),
          elevation: 0,
          title: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF005cbc),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: showProfile
              ? [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Container(
                      width: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        image: const DecorationImage(
                          image: AssetImage('assets/app_logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ]
              : null,
        ),
      ),
    ),
  );
}

Widget buildBadge(String text, Color tc, Color bg, [IconData? icon]) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: tc.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: tc),
          const SizedBox(width: 6),
        ],
        Text(
          text,
          style: TextStyle(
            color: tc,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}

class SectionHeader extends StatelessWidget {
  final String title, subtitle;
  const SectionHeader({super.key, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }
}

/// Widget latar belakang modern dengan siluet biru-putih transparan
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        // Base Color
        Container(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        ),
        // Siluet Dekoratif (Blobs)
        Positioned(
          top: -100,
          left: -50,
          child: _SilhouetteBlob(
            color: const Color(0xFF005ab7).withOpacity(isDark ? 0.08 : 0.04),
            size: 300,
          ),
        ),
        Positioned(
          bottom: 150,
          right: -100,
          child: _SilhouetteBlob(
            color: const Color(0xFF005ab7).withOpacity(isDark ? 0.06 : 0.03),
            size: 450,
          ),
        ),
        child,
      ],
    );
  }
}

class _SilhouetteBlob extends StatelessWidget {
  final Color color;
  final double size;
  const _SilhouetteBlob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 100,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }
}

Route createSmoothRoute(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(0.1, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOutQuart;

      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);
      final fadeAnimation = animation.drive(CurveTween(curve: Curves.easeIn));

      return FadeTransition(
        opacity: fadeAnimation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}

class DiscoverHeroSection extends StatelessWidget {
  final VoidCallback onStartLearning;
  final VoidCallback onTakeQuiz;

  const DiscoverHeroSection({
    super.key,
    required this.onStartLearning,
    required this.onTakeQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Kartu Gambar Utama
        Container(
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/hero_dashboard.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              // Label Discover Indonesia di bawah-tengah dengan efek glassmorphism
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: const Text(
                          'Discover Indonesia',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Tombol Navigasi di luar kartu gambar
        QuickNavSection(
          onStartLearning: onStartLearning,
          onTakeQuiz: onTakeQuiz,
          isDarkBackground: false,
        ),
      ],
    );
  }
}

class QuickNavSection extends StatelessWidget {
  final VoidCallback onStartLearning;
  final VoidCallback onTakeQuiz;
  final bool isDarkBackground;

  const QuickNavSection({
    super.key,
    required this.onStartLearning,
    required this.onTakeQuiz,
    this.isDarkBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color startLearningBg = isDarkBackground
        ? Colors.white.withOpacity(0.12)
        : const Color(0xFF005ab7);
    final Color takeQuizBg = isDarkBackground
        ? Colors.white.withOpacity(0.12)
        : const Color(0xFF83fba5);
    final Color textColor = Colors.white;
    final Color takeQuizTextColor = isDarkBackground
        ? Colors.white
        : const Color(0xFF00743a);

    return Column(
      children: [
        _NavButton(
          title: 'Mulai Belajar',
          subtitle: 'Start your adventure',
          icon: Icons.school,
          backgroundColor: startLearningBg,
          textColor: textColor,
          onTap: onStartLearning,
        ),
        const SizedBox(height: 16),
        _NavButton(
          title: 'Ambil Kuis',
          subtitle: 'Test your knowledge',
          icon: Icons.quiz,
          backgroundColor: takeQuizBg,
          textColor: takeQuizTextColor,
          onTap: onTakeQuiz,
        ),
      ],
    );
  }
}

class _NavButton extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _NavButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(milliseconds: 150),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.textColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            color: widget.textColor.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: widget.textColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KnowledgeCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String location;
  final String category; // TAMBAHKAN INI
  final String fact; // TAMBAHKAN INI
  final VoidCallback onTap;

  const KnowledgeCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.location,
    required this.category, // TAMBAHKAN INI
    required this.fact, // TAMBAHKAN INI
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // 1. Gambar Background
            Positioned.fill(
              child: Hero(
                tag: title,
                child: Image(
                  image: getImageProvider(imageUrl),
                  fit: BoxFit.cover,
                  // Tambahkan error builder agar tidak crash jika link gambar mati
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
            ),

            // 2. Overlay Gradient Gelap
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
            ),

            // 3. Nama Tempat dengan Shape di Tengah
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4. Label Lokasi & Category (Pojok Atas)
            Positioned(
              top: 15,
              left: 15,
              child: Row(
                children: [
                  // Badge Lokasi
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF005ab7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge Category
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String appLanguage;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.appLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _item(0, Icons.home_rounded, _translate('home')),
            _item(1, Icons.school_rounded, _translate('learn')),
            _item(2, Icons.quiz_rounded, _translate('quiz')),
            _item(3, Icons.settings_rounded, _translate('settings')),
          ],
        ),
      ),
    );
  }

  String _translate(String key) {
    final Map<String, Map<String, String>> translations = {
      'English US': {
        'home': 'Home',
        'learn': 'Learn',
        'quiz': 'Quiz',
        'settings': 'Settings',
      },
      'English UK': {
        'home': 'Home',
        'learn': 'Learn',
        'quiz': 'Quiz',
        'settings': 'Settings',
      },
      'Bahasa Indonesia': {
        'home': 'Beranda',
        'learn': 'Belajar',
        'quiz': 'Kuis',
        'settings': 'Pengaturan',
      },
      'Français': {
        'home': 'Accueil',
        'learn': 'Apprendre',
        'quiz': 'Quiz',
        'settings': 'Paramètres',
      },
      'Deutsch': {
        'home': 'Start',
        'learn': 'Lernen',
        'quiz': 'Quiz',
        'settings': 'Einstellungen',
      },
      '日本語': {'home': 'ホーム', 'learn': '学ぶ', 'quiz': 'クイズ', 'settings': '設定'},
    };
    return translations[appLanguage]?[key] ?? translations['English US']![key]!;
  }

  Widget _item(int index, IconData i, String l) {
    bool active = currentIndex == index;
    return InkWell(
      onTap: () => onTap(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF005abc).withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              i,
              color: active
                  ? const Color(0xFF005abc)
                  : Colors.grey.withOpacity(0.8),
              size: 24,
            ),
            if (active) ...[
              const SizedBox(width: 8),
              Text(
                l,
                style: const TextStyle(
                  color: Color(0xFF005abc),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class SearchFilterSection extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchFilterSection({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: "Search location...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}

class DailyProgressCard extends StatelessWidget {
  final double progress;

  const DailyProgressCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Daily Progress",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text("${(progress * 100).round()}%"),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
