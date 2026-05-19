// ==========================================
// 14. HALAMAN TERMS OF SERVICE (NEW)
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    const double stackLg = 40.0;
    const double marginMain = 24.0;
    const Color primaryColor = Color(0xFF005ab7);
    const Color secondaryColor = Color(0xFF006d36);
    const Color onSurfaceVariant = Color(0xFF414754);
    const Color outlineVariant = Color(0xFFc1c6d7);

    return Scaffold(
      backgroundColor: const Color(0xFFf7f9fb),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: AppBar(
              backgroundColor: const Color(0xFFf7f9fb).withOpacity(0.8),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF005cbc)),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text(
                'Legal Center',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: marginMain,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Hero Section ---
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMiniBadge(
                        'Terms of Service',
                        secondaryColor.withOpacity(0.1),
                        secondaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Terms of Service',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF191c1e),
                      letterSpacing: -0.64,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Last Updated: October 24, 2023. Our agreement on how you can use our services.',
                    style: TextStyle(fontSize: 16, color: onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: stackLg),

            // --- Article Layout ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: outlineVariant.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section 1 (Terms of Service content)
                  _buildSectionTitle('1. User Agreement', primaryColor),
                  const Text(
                    'By accessing our platform, you agree to be bound by these terms of service, all applicable laws and regulations, and agree that you are responsible for compliance with any applicable local laws.',
                    style: TextStyle(fontSize: 18, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFffdfa0).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: Color(0xFF956e00), width: 4),
                      ),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'USER CONDUCT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            color: Color(0xFF956e00),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '"Users must not engage in any activity that interferes with or disrupts the services. Unauthorized reproduction of educational materials is strictly prohibited."',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: stackLg),

                  // Section 2 (Additional Terms)
                  _buildSectionTitle('2. Intellectual Property', primaryColor),
                  const Text(
                    'All content, trademarks, and data on this platform, including but not limited to text, graphics, logos, and images, are the property of TravelEducation Inc. or its content suppliers and protected by international copyright laws.',
                    style: TextStyle(fontSize: 18, height: 1.6),
                  ),
                  const SizedBox(height: 16),
                  _buildBulletItem(
                    'Unauthorized use of any content is strictly prohibited.',
                    secondaryColor,
                  ),
                  _buildBulletItem(
                    'Users are granted a limited, non-exclusive, non-transferable license to access and use the platform for personal, non-commercial purposes.',
                    secondaryColor,
                  ),
                  const SizedBox(height: stackLg),

                  const Divider(color: outlineVariant),
                  const SizedBox(height: stackLg),

                  // Contact Section
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0072e5),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isWide = constraints.maxWidth > 500;
                        return Flex(
                          direction: isWide ? Axis.horizontal : Axis.vertical,
                          children: [
                            Expanded(
                              flex: isWide ? 1 : 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Need clarification?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'If you have any questions about these Terms of Service, please contact our support team.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
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
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: primaryColor,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 32,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                    child: const Text(
                                      'Contact Support',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isWide) const SizedBox(width: 32),
                            if (!isWide) const SizedBox(height: 32),
                            Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 4,
                                ),
                                color: Colors
                                    .white, // Tambahkan warna dasar agar tidak langsung biru
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/Adilskotak.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: stackLg),

            // Footer
            Center(
              child: Column(
                children: [
                  const Text(
                    'EXPLORE & LEARN LEGAL FRAMEWORK',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF717786),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '© 2023 TravelEducation Inc. All rights reserved.',
                    style: TextStyle(fontSize: 14, color: onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color bg, Color tc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        text,
        style: TextStyle(color: tc, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildBulletItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
