// ==========================================
// HALAMAN REGISTER (PLACEHOLDER)
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main_navigation_wrapper.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;
  final String appLanguage;
  final Function(String) onLanguageChanged;

  const RegisterPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
    required this.appLanguage,
    required this.onLanguageChanged,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _showTermsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Syarat & Ketentuan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005ab7),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildLegalItem(
                      '1. Persetujuan Layanan',
                      'Dengan mendaftar, Anda setuju untuk mematuhi semua peraturan yang ditetapkan oleh TravelEducation Inc. dalam pemakaian platform edukasi ini.',
                    ),
                    _buildLegalItem(
                      '2. Akun Pengguna',
                      'Anda bertanggung jawab penuh atas kerahasiaan kata sandi dan aktivitas yang terjadi di bawah akun Anda. Satu akun hanya untuk satu pengguna.',
                    ),
                    _buildLegalItem(
                      '3. Hak Kekayaan Intelektual',
                      'Semua konten edukasi, teks, dan gambar di aplikasi ini dilindungi hak cipta dan hanya untuk penggunaan pribadi non-komersial.',
                    ),
                    _buildLegalItem(
                      '4. Privasi & Data',
                      'Data yang Anda berikan akan dikelola sesuai dengan kebijakan privasi kami untuk meningkatkan pengalaman belajar dan eksplorasi Anda.',
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(color: Color(0xFF414754), height: 1.4),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Kebijakan Privasi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005ab7),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildLegalItem(
                      '1. Pengumpulan Data',
                      'Kami mengumpulkan informasi minimal seperti nama dan email untuk keperluan sinkronisasi progres belajar Anda.',
                    ),
                    _buildLegalItem(
                      '2. Keamanan Data',
                      'Data Anda dienkripsi dan tidak akan dibagikan kepada pihak ketiga tanpa persetujuan eksplisit dari Anda.',
                    ),
                    _buildLegalItem(
                      '3. Penggunaan Cookie',
                      'Aplikasi menggunakan penyimpanan lokal untuk menyimpan preferensi bahasa dan tema Anda.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password tidak cocok'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      // Simpan nama lengkap ke profil Firebase
      await userCredential.user?.updateDisplayName(_nameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Akun berhasil dibuat! Silakan masuk dengan email & password Anda.',
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Langsung pindah ke halaman Home (MainNavigationWrapper)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainNavigationWrapper(
              themeMode: widget.themeMode,
              onThemeChanged: widget.onThemeChanged,
              appLanguage: widget.appLanguage,
              onLanguageChanged: widget.onLanguageChanged,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Registrasi gagal'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005ab7);
    const Color secondaryColor = Color(0xFF006d36);
    const Color onSurfaceVariant = Color(0xFF414754);

    return Scaffold(
      backgroundColor: const Color(0xFFf7f9fb),
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.7),
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Daftar Akun',
                style: TextStyle(
                  color: primaryColor,
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
          // Visual Accent Background Elements (Blobs)
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Hero Branding Section
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/app_logo.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Mulai Petualanganmu',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Text(
                    'Jelajahi dunia dengan wawasan baru.',
                    style: TextStyle(color: onSurfaceVariant, fontSize: 16),
                  ),
                  const SizedBox(height: 32),

                  // Registration Form (Glass Card)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.1),
                              blurRadius: 60,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputField(
                              'Nama Lengkap',
                              Icons.person_outline,
                              'Masukkan nama lengkap',
                              controller: _nameController,
                            ),
                            const SizedBox(height: 20),
                            _buildInputField(
                              'Email',
                              Icons.mail_outline,
                              'contoh@email.com',
                              controller: _emailController,
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              'Password',
                              'Min. 8 karakter',
                              _passwordController,
                              _obscurePassword,
                              () {
                                setState(
                                  () => _obscurePassword = !_obscurePassword,
                                );
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildPasswordField(
                              'Konfirmasi Password',
                              'Ulangi password',
                              _confirmPasswordController,
                              _obscureConfirmPassword,
                              () {
                                setState(
                                  () => _obscureConfirmPassword =
                                      !_obscureConfirmPassword,
                                );
                              },
                              icon: Icons.lock_reset,
                            ),
                            const SizedBox(height: 20),
                            // Terms and Conditions
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _agreeToTerms,
                                  onChanged: (val) =>
                                      setState(() => _agreeToTerms = val!),
                                  activeColor: primaryColor,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text.rich(
                                      TextSpan(
                                        text: 'Saya setuju dengan ',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: onSurfaceVariant,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Syarat & Ketentuan',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = _showTermsDialog,
                                          ),
                                          const TextSpan(text: ' serta '),
                                          TextSpan(
                                            text: 'Kebijakan Privasi',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: primaryColor,
                                            ),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = _showPrivacyDialog,
                                          ),
                                          const TextSpan(
                                            text: ' TravelEducation Inc.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Submit Button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: (_agreeToTerms && !_isLoading)
                                    ? _register
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _agreeToTerms
                                      ? primaryColor
                                      : Colors.grey[400],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Daftar Akun',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Footer Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sudah punya akun? ',
                        style: TextStyle(color: onSurfaceVariant),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                themeMode: widget.themeMode,
                                onThemeChanged: widget.onThemeChanged,
                                appLanguage: widget.appLanguage,
                                onLanguageChanged: widget.onLanguageChanged,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Masuk di sini',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
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
    );
  }

  Widget _buildInputField(
    String label,
    IconData icon,
    String hint, {
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF414754),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: const Color(0xFFf2f4f6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(
    String label,
    String hint,
    TextEditingController controller,
    bool obscure,
    VoidCallback onToggle, {
    IconData icon = Icons.lock_outline,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF414754),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: const Color(0xFFf2f4f6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
