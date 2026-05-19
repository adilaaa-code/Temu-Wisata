// ==========================================
// 8. HALAMAN PENGATURAN TAMPILAN (APPEARANCE SETTINGS PAGE) - NEW
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';

class AppearanceSettingsPage extends StatefulWidget {
  final XFile? profileImage;
  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  const AppearanceSettingsPage({
    super.key,
    this.profileImage,
    required this.currentThemeMode,
    required this.onThemeChanged,
  });

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  late ThemeMode _selectedMode;

  @override
  void initState() {
    super.initState();
    _selectedMode = widget.currentThemeMode;
  }

  void _handleModeChange(ThemeMode mode) {
    setState(() {
      _selectedMode = mode;
    });
    widget.onThemeChanged(mode);
  }

  @override
  Widget build(BuildContext context) {
    bool isSystem = _selectedMode == ThemeMode.system;
    const Color primaryColor = Color(0xFF005ab7);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surface.withOpacity(0.8),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF005cbc)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Theme Mode',
                style: TextStyle(
                  color: Color(0xFF005ab7),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Color(0xFF191c1e),
                letterSpacing: -0.64,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customize how the interface looks on your device. Choose between light and dark themes.',
              style: TextStyle(fontSize: 16, color: Color(0xFF414754)),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _ThemeModeCard(
                    title: 'Light Mode',
                    subtitle: 'Classic and clear',
                    isSelected: !isSystem && _selectedMode == ThemeMode.light,
                    isDark: false,
                    onTap: () => _handleModeChange(ThemeMode.light),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ThemeModeCard(
                    title: 'Dark Mode',
                    subtitle: 'Easy on the eyes',
                    isSelected: !isSystem && _selectedMode == ThemeMode.dark,
                    isDark: true,
                    onTap: () => _handleModeChange(ThemeMode.dark),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: const Color(0xFFc1c6d7).withOpacity(0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007fff).withOpacity(0.05),
                    blurRadius: 30,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF83fba5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.settings_brightness,
                      color: Color(0xFF00743a),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'System Default',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Follow device theme settings',
                          style: TextStyle(
                            color: Color(0xFF414754),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isSystem,
                    onChanged: (val) {
                      _handleModeChange(
                        val ? ThemeMode.system : ThemeMode.light,
                      );
                    },
                    activeColor: const Color(0xFF0072e5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0072e5).withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF0072e5).withOpacity(0.1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info, color: Color(0xFF005ab7)),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Dark Mode',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Color(0xFF005ab7),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Dark mode reduces the light emitted by device screens while maintaining minimum color contrast ratios required for readability. It helps improve battery life on OLED screens and reduces eye strain in low-light environments.',
                          style: TextStyle(
                            color: Color(0xFF414754),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
            elevation: 8,
            shadowColor: primaryColor.withOpacity(0.3),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline),
              SizedBox(width: 8),
              Text(
                'Saya Mengerti & Setuju',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeModeCard extends StatelessWidget {
  final String title, subtitle;
  final bool isSelected, isDark;
  final VoidCallback onTap;

  const _ThemeModeCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0f172a)
                    : const Color(0xFFf8fafc),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0072e5)
                      : Colors.transparent,
                  width: 4,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.black12,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Column(
                            children: [
                              _mockItem(isDark),
                              const SizedBox(height: 8),
                              _mockItem(isDark),
                            ],
                          ),
                        ),
                        Container(
                          height: 24,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF3b82f6)
                                : const Color(0xFF2563eb),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0072e5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF414754),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mockItem(bool dark) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: dark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: dark
            ? Border.all(color: Colors.white.withOpacity(0.05))
            : Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: dark
                  ? Colors.blue[900]?.withOpacity(0.5)
                  : Colors.blue[100],
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white10
                        : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: dark
                          ? Colors.white10
                          : Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(2),
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
