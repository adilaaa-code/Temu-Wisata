// ==========================================
// 13. HALAMAN TENTANG APLIKASI (ABOUT APP PAGE) - NEW
// ==========================================
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutAppPage extends StatelessWidget {
  final XFile? profileImage;

  const AboutAppPage({super.key, this.profileImage});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005ab7);
    const Color secondaryColor = Color(0xFF006d36);

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
                'About App',
                style: TextStyle(
                  color: Color(0xFF005ab7),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Logo Section
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    'assets/app_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Temu Wisata',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.64,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Jendela Warisan Nusantara',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildBadge(
                  'Version v1.0.0',
                  const Color(0xFF00743a),
                  const Color(0xFF83fba5).withOpacity(0.3),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Temu Wisata adalah platform eksplorasi digital yang dirancang untuk menghubungkan petualang dengan kekayaan budaya dan keajaiban ekologi Indonesia. \n\nKami percaya bahwa perjalanan bukan sekadar berpindah tempat, melainkan proses belajar yang mendalam. Melalui Learning Paths yang imersif dan kuis interaktif, kami membantu Anda memahami sejarah, filosofi, dan keunikan setiap destinasi di nusantara.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF414754),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // Social Media Icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(
                      Icons.phone,
                      onTap: () async {
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
                    ),
                    const SizedBox(width: 16),
                    _buildSocialIcon(
                      Icons.mail,
                      onTap: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: 'adilaahmad22.id@gmail.com',
                          query: 'subject=Tanya Temu Wisata',
                        );
                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Stats Bento Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        '20+',
                        'Destinasi Terkurasi',
                        primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        '5 Level',
                        'Tantangan Kuis',
                        secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Footer
                Column(
                  children: [
                    const Text('Created by Adila Ahmad Ramdani'),
                    const SizedBox(height: 8),
                    const Text(
                      'LESTARI ALAM INDONESIA',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color textColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF005ab7)),
      ),
    );
  }

  Widget _buildStatCard(String val, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
