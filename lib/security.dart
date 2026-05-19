// ==========================================
// 10. HALAMAN PENGATURAN KEAMANAN (SECURITY SETTINGS PAGE) - NEW
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;

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
                'Security Settings',
                style: TextStyle(
                  color: Color(0xFF005cbc),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Change Password Section ---
            Row(
              children: [
                Icon(Icons.lock, color: primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildPasswordField(
                    label: 'Current Password',
                    hint: 'Enter current password',
                    obscure: _obscureCurrent,
                    onToggle: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                    controller: _currentPasswordController,
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: 'New Password',
                    hint: 'Enter new password',
                    obscure: _obscureNew,
                    onToggle: () => setState(() => _obscureNew = !_obscureNew),
                    controller: _newPasswordController,
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    label: 'Confirm New Password',
                    hint: 'Repeat new password',
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              final currentPassword = _currentPasswordController
                                  .text
                                  .trim();
                              final newPassword = _newPasswordController.text
                                  .trim();
                              final confirmPassword = _confirmPasswordController
                                  .text
                                  .trim();

                              if (currentPassword.isEmpty ||
                                  newPassword.isEmpty ||
                                  confirmPassword.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Semua kolom harus diisi.'),
                                  ),
                                );
                                return;
                              }
                              if (newPassword != confirmPassword) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Kata sandi baru tidak cocok.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              setState(() => _isLoading = true);
                              try {
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null && user.email != null) {
                                  // Firebase memerlukan re-autentikasi untuk tindakan sensitif
                                  AuthCredential credential =
                                      EmailAuthProvider.credential(
                                        email: user.email!,
                                        password: currentPassword,
                                      );

                                  await user.reauthenticateWithCredential(
                                    credential,
                                  );

                                  // Melakukan update password di Firebase
                                  await user.updatePassword(newPassword);

                                  // Logout otomatis agar sesi diperbarui dan user login dengan data baru
                                  await FirebaseAuth.instance.signOut();

                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Kata sandi berhasil diperbarui. Silakan masuk kembali.',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  }
                                }
                              } on FirebaseAuthException catch (e) {
                                String message =
                                    'Gagal memperbarui kata sandi.';
                                if (e.code == 'wrong-password') {
                                  message = 'Kata sandi saat ini salah.';
                                } else if (e.code == 'weak-password') {
                                  message = 'Kata sandi baru terlalu lemah.';
                                } else if (e.code == 'requires-recent-login') {
                                  message =
                                      'Sesi telah berakhir. Silakan login ulang.';
                                }

                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isLoading = false);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Simpan Kata Sandi Baru',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Security Information Section ---
            Row(
              children: [
                Icon(Icons.info_outline, color: primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Informasi Keamanan Akun',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: primaryColor.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.enhanced_encryption,
                    'Enkripsi End-to-End',
                    'Data pribadi dan riwayat perjalanan Anda dilindungi dengan enkripsi standar industri.',
                  ),
                  const Divider(height: 32),
                  _buildInfoRow(
                    Icons.history,
                    'Log Aktivitas',
                    'Kami memantau aktivitas login mencurigakan untuk mencegah akses tidak sah ke akun Anda.',
                  ),
                  const Divider(height: 32),
                  _buildInfoRow(
                    Icons.privacy_tip,
                    'Kepatuhan Privasi',
                    'Pengolahan data Anda sepenuhnya mematuhi regulasi perlindungan data yang berlaku.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Footer Info ---
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(text: 'Last password change: '),
                      TextSpan(
                        text: '3 months ago',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '. We recommend changing it every 6 months for optimal security.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: const Color(0xFF005ab7)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFf2f4f6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: onToggle,
            ),
          ),
        ),
      ],
    );
  }
}
