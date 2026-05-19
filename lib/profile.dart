// ==========================================
// 5. HALAMAN EDIT PROFILE (NEW)
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  final XFile? profileImage;
  final Future<XFile?> Function() onPickImage;

  const EditProfilePage({
    super.key,
    this.profileImage,
    required this.onPickImage,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  XFile? _previewImage;

  @override
  void initState() {
    super.initState();
    _previewImage = widget.profileImage;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _fullNameController.text = user?.displayName ?? "Explorer Name";
      _emailController.text = user?.email ?? "";
      _bioController.text =
          prefs.getString('user_bio') ??
          "Passionate world traveler and lifelong learner.";
    });

    _fullNameController.addListener(() {
      setState(() {});
    });

    // Tambahkan listener untuk memperbarui hitungan karakter bio
    _bioController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(_fullNameController.text.trim());
        await user.reload(); // Refresh data user lokal
        user = FirebaseAuth.instance.currentUser;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_bio', _bioController.text.trim());

      if (mounted) {
        // Mengirimkan 'true' agar halaman sebelumnya tahu ada perubahan data
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint("Error saving changes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisikan spasi dan warna umum berdasarkan konfigurasi Tailwind
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color primaryContainerColor = Theme.of(
      context,
    ).colorScheme.primaryContainer;
    final Color secondaryContainerColor = Theme.of(
      context,
    ).colorScheme.secondaryContainer;
    final Color tertiaryColor = Theme.of(context).colorScheme.tertiary;
    final Color tertiaryContainerColor = Theme.of(
      context,
    ).colorScheme.tertiaryContainer;
    final Color outlineColor = Theme.of(context).colorScheme.outline;
    final Color outlineVariantColor = Theme.of(
      context,
    ).colorScheme.outlineVariant;
    final Color surfaceContainerLow = Theme.of(
      context,
    ).colorScheme.surfaceContainerLow;
    final Color onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    final Color onPrimaryContainerColor = Theme.of(
      context,
    ).colorScheme.onPrimaryContainer;

    const double stackSm = 12.0;
    const double stackMd = 24.0;
    const double stackLg = 40.0;
    const double gutter = 16.0;
    const double marginMain = 24.0;
    const double base = 8.0;

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
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF005cbc)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Edit Profile',
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              marginMain,
              stackLg,
              marginMain,
              150,
            ), // Tambahkan padding untuk footer tetap
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(stackMd),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                      // Profile Picture Section
                      Stack(
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                              color: Colors.grey[200],
                            ),
                            child: ClipOval(
                              child: _previewImage == null
                                  ? const Image(
                                      image: AssetImage('assets/logo.jpg'),
                                      fit: BoxFit.cover,
                                    )
                                  : (kIsWeb ||
                                            _previewImage!.path.startsWith(
                                              'http',
                                            )
                                        ? Image.network(
                                            _previewImage!.path,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.file(
                                            File(_previewImage!.path),
                                            fit: BoxFit.cover,
                                          )),
                            ),
                          ),
                          Positioned(
                            bottom: base,
                            right: base,
                            child: GestureDetector(
                              onTap: () async {
                                final img = await widget.onPickImage();
                                if (img != null) {
                                  setState(() => _previewImage = img);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: primaryContainerColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.photo_camera,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: gutter),
                      Text(
                        _fullNameController.text.isNotEmpty
                            ? _fullNameController.text
                            : "Explorer Name",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: onSurfaceColor,
                        ),
                      ),
                      Text(
                        'Level 12 Traveler • 450 XP',
                        style: TextStyle(fontSize: 12, color: outlineColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: stackMd),

                // Form Section
                _buildGlassPanel(
                  context,
                  children: [
                    _buildInputField(
                      context,
                      label: 'Full Name',
                      icon: Icons.person,
                      controller: _fullNameController,
                      hintText: 'Enter your full name',
                    ),
                    _buildInputField(
                      context,
                      label: 'Email Address',
                      icon: Icons.mail,
                      controller: _emailController,
                      hintText: 'yourname@example.com',
                      keyboardType: TextInputType.emailAddress,
                      enabled:
                          false, // Email tidak boleh diubah agar tetap sama dengan saat daftar
                    ),
                    _buildInputField(
                      context,
                      label: 'Bio',
                      icon: Icons.info_outline,
                      controller: _bioController,
                      hintText: 'Tell us about yourself...',
                      maxLines: 4,
                      maxLength: 300,
                    ),
                  ],
                ),
                const SizedBox(height: stackMd),

                // Interests / Badges
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: base,
                    ), // px-2
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Travel Interests',
                          style: TextStyle(
                            fontSize: 14, // label-lg
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                          ),
                        ),
                        const SizedBox(height: stackSm), // mb-stack-sm
                        Wrap(
                          spacing: base, // gap-2
                          runSpacing: base,
                          children: [
                            _buildInterestBadge(
                              context,
                              'Flora',
                              Icons.forest,
                              secondaryContainerColor.withOpacity(0.2),
                              Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              secondaryContainerColor.withOpacity(0.3),
                            ),
                            _buildInterestBadge(
                              context,
                              'Ocean Life',
                              Icons.waves,
                              primaryContainerColor.withOpacity(0.1),
                              primaryColor,
                              primaryContainerColor.withOpacity(0.2),
                            ),
                            _buildInterestBadge(
                              context,
                              'Peaks',
                              Icons.terrain,
                              tertiaryContainerColor.withOpacity(0.1),
                              tertiaryColor,
                              tertiaryContainerColor.withOpacity(0.2),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                // Logika untuk menambahkan minat lainnya
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ), // px-4 py-1.5
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    9999,
                                  ), // rounded-full
                                ),
                                side: BorderSide(color: outlineVariantColor),
                                foregroundColor: outlineColor,
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                '+ Add More',
                                style: TextStyle(
                                  fontSize: 12, // label-sm
                                  fontWeight: FontWeight.w500,
                                  color: outlineColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Fixed Bottom Action Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(
                    marginMain,
                    gutter,
                    marginMain,
                    stackMd,
                  ), // px-margin-main pb-8 pt-4
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.8),
                    border: Border(
                      top: BorderSide(color: Colors.white.withOpacity(0.2)),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(
                          255,
                          0,
                          128,
                          255,
                        ).withOpacity(0.1), // rgba(0,127,255,0.1)
                        blurRadius: 30,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: gutter,
                            ), // py-4 px-6
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                9999,
                              ), // rounded-full
                            ),
                            side: BorderSide(
                              color: primaryContainerColor.withOpacity(0.3),
                            ),
                            foregroundColor: primaryColor,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 14, // label-lg
                              fontWeight: FontWeight.w600,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: gutter), // gap-4
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.save, color: Colors.white),
                          label: Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 14, // label-lg
                              fontWeight: FontWeight.w600,
                              color: onPrimaryContainerColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryContainerColor,
                            foregroundColor: onPrimaryContainerColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: gutter,
                            ), // py-4 px-6
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                9999,
                              ), // rounded-full
                            ),
                            elevation: 8, // shadow-lg
                            shadowColor: const Color(
                              0xFF007fff,
                            ).withOpacity(0.2), // shadow-blue-500/20
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassPanel(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24), // p-6
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).cardColor.withOpacity(0.8), // glass-panel background
        borderRadius: BorderRadius.circular(24), // rounded-3xl
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ), // glass-panel border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // shadow-sm
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            children
                .map(
                  (child) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ), // space-y-gutter
                    child: child,
                  ),
                )
                .toList()
              ..removeLast(), // Hapus padding bawah dari item terakhir
      ),
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required String label,
    required IconData icon,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    bool enabled = true,
    int? maxLines = 1,
    int? maxLength,
    Widget? suffixWidget,
  }) {
    final Color outlineColor = Theme.of(context).colorScheme.outline;
    final Color surfaceContainerLow = Theme.of(
      context,
    ).colorScheme.surfaceContainerLow;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Stack(
          children: [
            TextField(
              controller: controller,
              keyboardType: keyboardType,
              enabled: enabled,
              maxLines: maxLines,
              maxLength: maxLength,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                fillColor: surfaceContainerLow,
                contentPadding: const EdgeInsets.fromLTRB(48, 16, 16, 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                counterText: "",
              ),
            ),
            Positioned(
              left: 16,
              top: maxLines! > 1 ? 16 : 0,
              bottom: maxLines > 1 ? null : 0,
              child: Align(
                alignment: maxLines > 1
                    ? Alignment.topLeft
                    : Alignment.centerLeft,
                child: Icon(icon, color: outlineColor, size: 20),
              ),
            ),
            if (suffixWidget != null)
              Positioned(bottom: 8, right: 16, child: suffixWidget),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestBadge(
    BuildContext context,
    String text,
    IconData icon,
    Color bgColor,
    Color textColor,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ), // px-4 py-1.5
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(9999), // rounded-full
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor), // text-[16px]
          const SizedBox(width: 8), // gap-2
          Text(
            text,
            style: TextStyle(
              fontSize: 12, // label-sm
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
