// --- WRAPPER UTAMA UNTUK NAVIGASI ---
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'learn.dart';
import 'quiz.dart';
import 'settings.dart';
import 'costum_widget.dart';
import 'knowledge_data.dart';

class MainNavigationWrapper extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode themeMode;
  final String appLanguage;
  final Function(String) onLanguageChanged;

  const MainNavigationWrapper({
    super.key,
    required this.onThemeChanged,
    required this.themeMode,
    required this.appLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  // State untuk menyimpan data foto profil secara global di aplikasi
  XFile? _profileImage;

  // State untuk Progres Belajar
  final Set<String> _readMaterials = {};
  bool _isQuizCompleted = false;
  final Set<String> _downloadedMaps = {};
  bool _wifiOnly = true;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk memuat data yang tersimpan saat pertama kali masuk
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = FirebaseAuth.instance.currentUser;

      // Load Profile Image
      // Gunakan UID agar foto tersimpan spesifik per akun dan permanen
      String? imagePath = user != null ? prefs.getString('profile_image_path_${user.uid}') : null;
      imagePath ??= user?.photoURL; // Fallback ke photoURL Firebase jika prefs kosong

      // Load Progress
      final List<String>? savedMaterials = prefs.getStringList(
        'read_materials',
      );
      final bool quizStatus = prefs.getBool('is_quiz_completed') ?? false;
      final List<String>? savedMaps = prefs.getStringList('downloaded_maps');
      final bool wifiSetting = prefs.getBool('wifi_only_setting') ?? true;

      setState(() {
        if (imagePath != null) {
          if (kIsWeb || imagePath!.startsWith('http')) {
            _profileImage = XFile(imagePath);
          } else if (File(imagePath).existsSync()) {
            _profileImage = XFile(imagePath);
          }
        }
        if (savedMaterials != null) {
          _readMaterials.addAll(savedMaterials);
        }
        _isQuizCompleted = quizStatus;
        if (savedMaps != null) {
          _downloadedMaps.addAll(savedMaps);
        }
        _wifiOnly = wifiSetting;
      });
    } catch (e) {
      debugPrint("Error loading saved data: $e");
    }
  }

  void _markMaterialAsRead(String title) async {
    if (!_readMaterials.contains(title)) {
      setState(() {
        _readMaterials.add(title);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('read_materials', _readMaterials.toList());
    }
  }

  void _markQuizAsCompleted() async {
    if (!_isQuizCompleted) {
      setState(() {
        _isQuizCompleted = true;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_quiz_completed', true);
    }
  }

  void _toggleMapDownload(String title) async {
    setState(() {
      if (_downloadedMaps.contains(title)) {
        _downloadedMaps.remove(title);
      } else {
        _downloadedMaps.add(title);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('downloaded_maps', _downloadedMaps.toList());
  }

  void _updateWifiSetting(bool value) async {
    setState(() => _wifiOnly = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wifi_only_setting', value);
  }

  Future<XFile?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _profileImage = image;
        });

        // Simpan path gambar ke SharedPreferences secara otomatis
        final prefs = await SharedPreferences.getInstance();
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Simpan dengan UID agar tidak hilang saat ganti akun atau restart aplikasi
          await prefs.setString('profile_image_path_${user.uid}', image.path);
          await user.updatePhotoURL(image.path);
        }

        return image;
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
    return null;
  }

  // Fungsi untuk pindah halaman dari tombol di Dashboard
  void _navigateTo(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double _calculateTotalProgress() {
    final int totalMaterials = KnowledgeData.items.length;
    double learnProgress = totalMaterials > 0
        ? (_readMaterials.length / totalMaterials) * 0.8
        : 0.0;
    double quizProgress = _isQuizCompleted ? 0.2 : 0.0;
    return learnProgress + quizProgress;
  }

  @override
  Widget build(BuildContext context) {
    final double totalProgress = _calculateTotalProgress();

    // List halaman utama
    final List<Widget> _pages = [
      DashboardPage(
        onStartLearning: () => _navigateTo(1),
        onTakeQuiz: () => _navigateTo(2),
        dailyProgress: totalProgress,
        readMaterials: _readMaterials,
        onMaterialRead: _markMaterialAsRead,
        downloadedMaps: _downloadedMaps,
        onToggleDownload: _toggleMapDownload,
        wifiOnly: _wifiOnly,
      ),
      LearnPage(
        readMaterials: _readMaterials,
        onMaterialRead: _markMaterialAsRead,
        downloadedMaps: _downloadedMaps,
        onToggleDownload: _toggleMapDownload,
        wifiOnly: _wifiOnly,
      ),
      QuizPage(
        onQuizCompleted: _markQuizAsCompleted,
        onGoHome: () => _navigateTo(0),
      ),
      SettingsPage(
        profileImage: _profileImage,
        onPickImage: _pickImage,
        downloadedMaps: _downloadedMaps,
        onRemoveMap: _toggleMapDownload,
        wifiOnly: _wifiOnly,
        onWifiChanged: _updateWifiSetting,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: AppBackground(
        child: IndexedStack(index: _selectedIndex, children: _pages),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        appLanguage: widget.appLanguage,
      ),
    );
  }
}
