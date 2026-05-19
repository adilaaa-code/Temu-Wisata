// ==========================================
// 4. HALAMAN PENGATURAN (SETTINGS PAGE)
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile.dart';
import 'security.dart';
import 'termsofservice.dart';
import 'storagedata.dart';
import 'about.dart';
import 'costum_widget.dart';
import 'login.dart';

class SettingsPage extends StatefulWidget {
  final XFile? profileImage;
  final Future<XFile?> Function() onPickImage;
  final Set<String> downloadedMaps;
  final Function(String) onRemoveMap;
  final bool wifiOnly;
  final Function(bool) onWifiChanged;

  const SettingsPage({
    super.key,
    this.profileImage,
    required this.onPickImage,
    required this.downloadedMaps,
    required this.onRemoveMap,
    required this.wifiOnly,
    required this.onWifiChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      _currentUser = FirebaseAuth.instance.currentUser;
    }
    if (mounted) setState(() { });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: buildBlurredAppBar(context, 'Settings'),
      body: CustomScrollView(
        cacheExtent: 500, // Menyiapkan area rendering tambahan untuk scroll yang lebih mulus
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                RepaintBoundary(
                  child: _buildProfileCard(context),
                ),
                const SizedBox(height: 32),
                
                _buildSectionHeader(context, "Preferences"),
                RepaintBoundary(
                  child: _buildGroupContainer(context, [
                    _buildSettingsTile(
                    context,
                    Icons.storage_outlined,
                    "Storage & Data",
                    "Manage your offline content",
                    onTap: () {
                      Navigator.push(
                        context,
                        createSmoothRoute(
                          StorageDataPage(
                            profileImage: widget.profileImage,
                            downloadedMaps: widget.downloadedMaps,
                            onRemoveMap: widget.onRemoveMap,
                            wifiOnly: widget.wifiOnly,
                            onWifiChanged: widget.onWifiChanged,
                          ),
                        ),
                      );
                    },
                  ),
                  ]),
                ),
                const SizedBox(height: 24),
                
                _buildSectionHeader(context, "Privacy & Security"),
                RepaintBoundary(
                  child: _buildGroupContainer(context, [
                    _buildSettingsTile(
                    context,
                    Icons.security_outlined,
                    "Security",
                    "Password & Privacy",
                    onTap: () {
                      Navigator.push(
                        context,
                        createSmoothRoute(
                          const SecuritySettingsPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(indent: 56, endIndent: 16, height: 1),
                  _buildSettingsTile(
                    context,
                    Icons.description_outlined,
                    "Terms of Service",
                    "App usage agreement",
                    onTap: () {
                      Navigator.push(
                        context,
                        createSmoothRoute(
                          const TermsOfServicePage(),
                        ),
                      );
                    },
                  ),
                  ]),
                ),
                const SizedBox(height: 24),
                
                _buildSectionHeader(context, "Support & Info"),
                RepaintBoundary(
                  child: _buildGroupContainer(context, [
                    _buildSettingsTile(
                    context,
                    Icons.help_outline,
                    "Help Center",
                    "FAQ & Support",
                    onTap: () {
                      Navigator.push(
                        context,
                        createSmoothRoute(const HelpCenterPage()),
                      );
                    },
                  ),
                  const Divider(indent: 56, endIndent: 16, height: 1),
                  _buildSettingsTile(
                  context,
                  Icons.info_outline,
                  "About App",
                  "Version 1.0.0",
                  onTap: () {
                    Navigator.push(
                      context,
                      createSmoothRoute(
                        AboutAppPage(
                          profileImage: widget.profileImage,
                        ),
                      ),
                    );
                  },
                ),
                  ]),
                ),
                const SizedBox(height: 40),
                RepaintBoundary(
                  child: _buildLogoutButton(context),
                ),
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupContainer(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: widget.onPickImage,
            child: Stack(
              children: [
                RepaintBoundary(
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    backgroundImage: widget.profileImage == null
                        ? const AssetImage('assets/logoapp.png') as ImageProvider
                        : (kIsWeb || widget.profileImage!.path.startsWith('http')
                            ? ResizeImage(
                                NetworkImage(widget.profileImage!.path), 
                                width: 200, 
                                height: 200
                              )
                            : ResizeImage(
                                FileImage(File(widget.profileImage!.path)), 
                                width: 200, 
                                height: 200
                              ) as ImageProvider),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentUser?.displayName ?? "User Name",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 4),
          Text(
            _currentUser?.email ?? "User Email",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const Divider(height: 32),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  createSmoothRoute(
                    EditProfilePage(
                      profileImage: widget.profileImage,
                      onPickImage: widget.onPickImage,
                    ),
                  ),
                ).then((value) {
                  if (value == true) _loadUserData();
                });
              },
              icon: const Icon(Icons.edit_note, size: 20),
              label: const Text("Edit Profil & Informasi"),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Log Out"),
              content: const Text("Are you sure you want to log out?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context); // Close dialog
                    await FirebaseAuth.instance.signOut();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
          // Tidak perlu Navigator.push karena StreamBuilder di main.dart 
          // akan otomatis memindahkan user ke LoginPage saat status berubah menjadi null.
        },
        leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
        title: Text(
          "Log Out",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.error,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 12. HALAMAN PUSAT BANTUAN (HELP CENTER PAGE) - NEW
// ==========================================
class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme.of(context).colorScheme for consistent theming
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final user = FirebaseAuth.instance.currentUser;

    String getInitials(String? name) {
      if (name == null || name.isEmpty) return "U";
      List<String> names = name.split(" ");
      String initials = "";
      int numWords = names.length > 2 ? 2 : names.length;
      for (var i = 0; i < numWords; i++) {
        if (names[i].isNotEmpty) {
          initials += names[i][0].toUpperCase();
        }
      }
      return initials.isEmpty ? "U" : initials;
    }

    // Custom color that doesn't directly map to ColorScheme, derived from original HTML
    // This color (0xFFd7e2ff) is a very light blue, similar to a light primary container.
    const Color customPrimaryFixedColor = Color(0xFFd7e2ff);

    // Define spacing based on Tailwind config in HTML
    const double stackSm = 12.0;
    const double stackMd = 24.0;
    const double stackLg = 40.0;
    const double gutter = 16.0;
    const double marginMain = 24.0;
    // const double base = 8.0; // Not directly used in this page's spacing, but defined in Tailwind

    return Scaffold(
      // Use Theme.of(context).colorScheme.surface for background
      backgroundColor: colorScheme.surface,
      // TopAppBar
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: colorScheme.surface.withOpacity(
                0.8,
              ), // bg-surface/80 backdrop-blur-md
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: Icon(
                  // Use colorScheme.primary for consistency
                  Icons.arrow_back,
                  color: colorScheme.primary,
                ), // text-blue-600
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                // Changed title to reflect the page
                'Help Center',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize:
                      textTheme.titleLarge?.fontSize, // Use theme text style
                  fontFamily: textTheme.titleLarge?.fontFamily,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section with Search
            Container(
              padding: EdgeInsets.only(
                top: stackMd,
                bottom: stackSm,
                left: marginMain,
                right: marginMain,
              ), // pt-24 pb-12 px-margin-main (adjusted for AppBar)
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    customPrimaryFixedColor, // Use the custom defined color
                    colorScheme.surface, // Use theme surface color
                  ], // from-primary-fixed to-surface
                ),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600), // max-w-4xl
                  child: Column(
                    children: [
                      Text(
                        'Pusat Bantuan', // h2
                        style: textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurface, // Use theme onSurface
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: stackSm), // mb-stack-sm
                      Text(
                        'Kami siap membantu perjalanan edukasi dan petualangan Anda.', // p
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme
                              .onSurfaceVariant, // Use theme onSurfaceVariant
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: stackMd), // mb-stack-md
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            9999,
                          ), // rounded-full
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // shadow-lg
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9999),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText:
                                    'Apa yang bisa kami bantu?', // placeholder
                                hintStyle: TextStyle(
                                  color: colorScheme
                                      .outline, // Use theme outline color
                                ), // text-outline
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: colorScheme
                                      .outline, // Use theme outline color
                                ), // material-symbols-outlined text-outline
                                filled: true,
                                fillColor: colorScheme.surface.withOpacity(
                                  0.8,
                                ), // glass-card background
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 24,
                                ), // pl-14 pr-6 (adjusted for prefixIcon)
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9999),
                                  borderSide: BorderSide(
                                    color: colorScheme.outlineVariant
                                        .withOpacity(0.2),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9999),
                                  borderSide: BorderSide(
                                    color: colorScheme.outlineVariant
                                        .withOpacity(0.2),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9999),
                                  borderSide: BorderSide(
                                    color: colorScheme
                                        .primary, // Use theme primary color
                                    width: 2,
                                  ), // focus:ring-2 focus:ring-primary
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // FAQ Categories Bento Grid
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: marginMain,
                vertical: stackLg,
              ), // px-margin-main py-stack-lg
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960), // max-w-6xl
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori Populer',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: stackMd), // mb-stack-md
                    LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWide =
                            constraints.maxWidth > 768; // md:grid-cols-3
                        if (isWide) {
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _buildCategoryCard(
                                    context,
                                    icon: Icons.school,
                                    iconBgColor: colorScheme.secondaryContainer,
                                    iconColor: colorScheme.onSecondaryContainer,
                                    title: 'Panduan Learning Paths',
                                    subtitle:
                                        'Cara memaksimalkan fitur edukasi dan mendapatkan sertifikat di setiap destinasi yang Anda kunjungi.',
                                  content: 'Selamat datang di Panduan Learning Paths Temu Wisata!\n\n'
                                      '1. Jelajahi Destinasi: Buka tab "Learn" untuk melihat daftar keajaiban Indonesia yang dikategorikan per wilayah.\n\n'
                                      '2. Pelajari & Simpan: Baca fakta unik (Fun Fact) dan deskripsi sejarah yang mendalam. Gunakan fitur "Download Peta" agar tetap bisa belajar meski tanpa sinyal.\n\n'
                                      '3. Tandai Progres: Klik "Tandai Sudah Dibaca" untuk mencatat materi yang telah Anda kuasai. Progres ini akan muncul di dashboard harian Anda.\n\n'
                                      '4. Uji Pengetahuan: Setelah membaca, tantang diri Anda di tab "Quiz". Setiap level memiliki tingkat kesulitan yang berbeda.\n\n'
                                      '5. Raih XP & Level: Kumpulkan poin pengalaman (XP) dari kuis untuk meningkatkan status Traveler Anda.',
                                    isWide: isWide,
                                  ),
                                ),
                                const SizedBox(width: gutter),
                                Expanded(
                                  flex: 1,
                                  child: _buildCategoryCard(
                                    context,
                                    icon: Icons.description,
                                    iconBgColor: colorScheme.outlineVariant
                                        .withOpacity(0.3),
                                    iconColor: colorScheme.onSurface,
                                    title: 'Dokumen Perjalanan',
                                    subtitle:
                                        'Persyaratan visa dan dokumen kesehatan.',
                                  content: 'Persiapan dokumen adalah kunci perjalanan yang nyaman:\n\n'
                                      '• Identitas Resmi: Pastikan membawa KTP asli untuk wisatawan domestik atau Paspor dengan masa berlaku minimal 6 bulan untuk wisatawan mancanegara.\n\n'
                                      '• Salinan Digital: Simpan foto/PDF tiket pesawat, kereta, dan konfirmasi hotel di folder "Favorit" galeri ponsel Anda untuk akses cepat.\n\n'
                                      '• Izin Kawasan Khusus: Untuk destinasi seperti Taman Nasional Komodo atau pendakian Rinjani, pastikan Anda sudah memiliki SIMAKSI (Surat Izin Masuk Kawasan Konservasi) yang dicetak atau tersedia secara digital.\n\n'
                                      '• Aplikasi Kesehatan: Selalu siapkan aplikasi kesehatan resmi pemerintah (SatuSehat) untuk verifikasi status kesehatan jika diminta di bandara atau pelabuhan.\n\n'
                                      '• Asuransi Perjalanan: Sangat disarankan memiliki asuransi yang mencakup evakuasi medis, terutama jika Anda berencana melakukan kegiatan luar ruangan yang ekstrem.',
                                    isWide: isWide,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Column(
                            children: [
                              _buildCategoryCard(
                                context,
                                icon: Icons.school,
                                iconBgColor: colorScheme.secondaryContainer,
                                iconColor: colorScheme.onSecondaryContainer,
                                title: 'Panduan Learning Paths',
                                subtitle:
                                    'Cara memaksimalkan fitur edukasi dan mendapatkan sertifikat di setiap destinasi yang Anda kunjungi.',
                                  content: 'Selamat datang di Panduan Learning Paths Temu Wisata!\n\n'
                                      '1. Jelajahi Destinasi: Buka tab "Learn" untuk melihat daftar keajaiban Indonesia yang dikategorikan per wilayah.\n\n'
                                      '2. Pelajari & Simpan: Baca fakta unik (Fun Fact) dan deskripsi sejarah yang mendalam. Gunakan fitur "Download Peta" agar tetap bisa belajar meski tanpa sinyal.\n\n'
                                      '3. Tandai Progres: Klik "Tandai Sudah Dibaca" untuk mencatat materi yang telah Anda kuasai. Progres ini akan muncul di dashboard harian Anda.\n\n'
                                      '4. Uji Pengetahuan: Setelah membaca, tantang diri Anda di tab "Quiz". Setiap level memiliki tingkat kesulitan yang berbeda.\n\n'
                                      '5. Raih XP & Level: Kumpulkan poin pengalaman (XP) dari kuis untuk meningkatkan status Traveler Anda.',
                                isWide: isWide,
                              ),
                              const SizedBox(height: gutter),
                              _buildCategoryCard(
                                context,
                                icon: Icons.description,
                                iconBgColor:
                                    colorScheme.outlineVariant.withOpacity(0.3),
                                iconColor: colorScheme.onSurface,
                                title: 'Dokumen Perjalanan',
                                subtitle:
                                    'Persyaratan visa dan dokumen kesehatan.',
                                  content: 'Persiapan dokumen adalah kunci perjalanan yang nyaman:\n\n'
                                      '• Identitas Resmi: Pastikan membawa KTP asli untuk wisatawan domestik atau Paspor dengan masa berlaku minimal 6 bulan untuk wisatawan mancanegara.\n\n'
                                      '• Salinan Digital: Simpan foto/PDF tiket pesawat, kereta, dan konfirmasi hotel di folder "Favorit" galeri ponsel Anda untuk akses cepat.\n\n'
                                      '• Izin Kawasan Khusus: Untuk destinasi seperti Taman Nasional Komodo atau pendakian Rinjani, pastikan Anda sudah memiliki SIMAKSI (Surat Izin Masuk Kawasan Konservasi) yang dicetak atau tersedia secara digital.\n\n'
                                      '• Aplikasi Kesehatan: Selalu siapkan aplikasi kesehatan resmi pemerintah (SatuSehat) untuk verifikasi status kesehatan jika diminta di bandara atau pelabuhan.\n\n'
                                      '• Asuransi Perjalanan: Sangat disarankan memiliki asuransi yang mencakup evakuasi medis, terutama jika Anda berencana melakukan kegiatan luar ruangan yang ekstrem.',
                                isWide: false,
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Contact Support Section
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: marginMain,
              ), // px-margin-main
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960), // max-w-6xl
                child: Container(
                  margin: const EdgeInsets.only(bottom: stackLg), // mb-stack-lg
                  padding: EdgeInsets.all(stackMd), // p-stack-md md:p-stack-lg
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32), // rounded-3xl
                    color: colorScheme.primary, // Menggunakan warna biru utama (Primary)
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // shadow-xl
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative circle
                      Positioned(
                        bottom: -stackMd * 2, // -bottom-24
                        right: -stackMd * 2, // -right-24
                        child: Container(
                          width: 256, // w-64
                          height: 256, // h-64
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary.withOpacity(
                              0.1,
                            ), // bg-white/10
                            borderRadius: BorderRadius.circular(
                              9999,
                            ), // rounded-full
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.onPrimary.withOpacity(0.05),
                                blurRadius: 30, // blur-3xl
                              ),
                            ],
                          ),
                        ),
                      ),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          bool isWide =
                              constraints.maxWidth > 768; // md:grid-cols-2
                          return Flex(
                            direction: isWide ? Axis.horizontal : Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: isWide ? 1 : 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Masih butuh bantuan?',
                                      style: textTheme.headlineLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme
                                            .onPrimary, // Use theme onPrimary
                                      ),
                                    ),
                                    const SizedBox(
                                      height: stackSm,
                                      // mb-stack-sm
                                    ), // mb-stack-sm
                                    Text(
                                      'Tim spesialis kami siap membantu Anda 24/7 untuk memastikan pengalaman belajar dan perjalanan Anda lancar.', // p
                                      style: TextStyle(
                                        fontSize: 18, // body-lg
                                        color: colorScheme.onPrimary
                                            .withOpacity(0.9), // opacity-90
                                      ),
                                    ),
                                    const SizedBox(
                                      height: stackMd,
                                    ), // mb-stack-md
                                    Wrap(
                                      spacing: gutter, // gap-4
                                      runSpacing: gutter,
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            final Uri whatsappUri = Uri.parse(
                                              'https://wa.me/6287782024780',
                                            );
                                            if (await canLaunchUrl(whatsappUri)) {
                                              await launchUrl(
                                                whatsappUri,
                                                mode: LaunchMode.externalApplication,
                                              );
                                            }
                                          },
                                          icon: Icon(
                                            Icons.chat,
                                            color: colorScheme.primary,
                                          ),
                                          label: Text(
                                            'Live Chat',
                                            style: TextStyle(
                                              color: colorScheme.primary,
                                              fontSize: 14, // label-lg
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: colorScheme
                                                .onPrimary, // bg-white
                                            padding: EdgeInsets.symmetric(
                                              horizontal: stackMd,
                                              vertical: stackSm,
                                            ), // px-6 py-3
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                            ), // rounded-full
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                          ),
                                        ),
                                        OutlinedButton.icon(
                                          onPressed: () async {
                                            final Uri emailLaunchUri = Uri(
                                              scheme: 'mailto',
                                              path: 'adilaahmad22.id@gmail.com',
                                              query: 'subject=Pusat Bantuan Temu Wisata',
                                            );
                                            if (await canLaunchUrl(emailLaunchUri)) {
                                              await launchUrl(emailLaunchUri);
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.mail,
                                            color: Colors.white,
                                          ), // text-white
                                          label: Text(
                                            'Email Support',
                                            style: TextStyle(
                                              color: Colors.white, // text-white
                                              fontSize: 14, // label-lg
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: Colors.transparent, // Transparan agar kontras dengan background biru
                                            side: BorderSide(
                                              // Use theme onPrimary for border
                                              color: colorScheme.onPrimary
                                                  .withOpacity(0.6),
                                            ), // border border-white/30
                                            padding: EdgeInsets.symmetric(
                                              horizontal: stackMd,
                                              vertical: stackSm,
                                            ), // px-6 py-3
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(9999),
                                            ), // rounded-full
                                            elevation: 0,
                                            shadowColor: Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (isWide)
                                const SizedBox(width: stackMd), // gap-stack-md
                              if (!isWide)
                                const SizedBox(height: stackMd), // gap-stack-md
                              if (isWide)
                                Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      16,
                                    ), // rounded-2xl
                                    child: Transform.rotate(
                                      // rotate-3
                                      angle:
                                          3 *
                                          // ignore: unnecessary_parenthesis
                                          (3.1415926535 /
                                              180), // Convert degrees to radians
                                      child: Image.network(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDydejjiVf1ch1fCb59fCuVf5aLI1FQwpm2pX5GWGRVtCZfjduPGHK7WY3IjVQIYlkeFVpFVVZBNTCS8A_3WnwY00fhLgnFp6Xfn69AYjAjUey6q2lX9prArm29mV_T6OnIOlhAjMMfG1YFqibfJHEU28OXmsu_Dr7hj_I2yx7LJRvlDEqqxqeTnu0zrqpNtZMnDDgwYWOYsExEkBRN3sYb9-otF7NNF1PhVhaoymMaEC9DB5Z78Asu64kxnMRC1PI0m_osyWiUNw4',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Secondary Links
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: marginMain,
                vertical: stackMd,
              ), // px-margin-main py-stack-md
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960), // max-w-6xl
                  child: Column(
                    children: [
                      Divider(
                        color: colorScheme
                            .outlineVariant, // Use theme outlineVariant
                        thickness: 1,
                      ), // border-t border-outline-variant
                      const SizedBox(height: stackMd), // pt-stack-md
                      OutlinedButton.icon(
                        onPressed: () async {
                          final Uri emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'adilaahmad22.id@gmail.com',
                          );
                          if (await canLaunchUrl(emailLaunchUri)) {
                            await launchUrl(emailLaunchUri);
                          }
                        },
                        icon: Icon(Icons.email_outlined, color: colorScheme.primary),
                        label: Text(
                          'Hubungi Kami',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: BorderSide(color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ), // To ensure content is not hidden by bottom nav bar
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isWide,
    required String content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const double stackMd = 24.0;
    const double gutter = 16.0;
    const double base = 8.0;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(content, style: theme.textTheme.bodyLarge?.copyWith(height: 1.6)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(stackMd),
        decoration: BoxDecoration(
          color: colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.outlineVariant.withOpacity(0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: isWide ? 80 : 64,
              height: isWide ? 80 : 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isWide ? 9999 : 12),
                color: iconBgColor,
              ),
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: iconColor,
                size: isWide ? 48 : 32,
              ),
            ),
            SizedBox(
              width: isWide ? gutter : 0,
              height: isWide ? 0 : gutter,
            ),
            Flexible(
              flex: isWide ? 1 : 0,
              fit: isWide ? FlexFit.tight : FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: base),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
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
