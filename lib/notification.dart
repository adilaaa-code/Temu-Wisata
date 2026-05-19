// ==========================================
// 7. HALAMAN PENGATURAN NOTIFIKASI (NOTIFICATION SETTINGS PAGE) - NEW
// ==========================================
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';

class NotificationSettingsPage extends StatefulWidget {
  final XFile? profileImage;

  const NotificationSettingsPage({super.key, this.profileImage});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _generalNotif = true;
  bool _tourReminders = true;
  bool _promoOffers = false;
  bool _appUpdates = true;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005ab7);
    const Color onSurfaceVariant = Color(0xFF414754);
    const Color outlineColor = Color(0xFF717786);

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
                'Notifications',
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              'Stay Connected',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: primaryColor,
                letterSpacing: -0.02,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Customize how you want to receive updates about your journeys and learning progress.',
              style: TextStyle(fontSize: 16, color: onSurfaceVariant),
            ),
            const SizedBox(height: 40),

            // Group: Activity Updates
            _buildSectionHeader(
              Icons.notifications_active,
              'Activity Updates',
              primaryColor,
              outlineColor,
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              'General Notifications',
              'Get alerts about new features, travel tips, and account security updates.',
              _generalNotif,
              (val) => setState(() => _generalNotif = val),
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              'Tour Reminders',
              'Timely notifications about upcoming bookings, flight changes, and meeting points.',
              _tourReminders,
              (val) => setState(() => _tourReminders = val),
            ),
            const SizedBox(height: 40),

            // Illustration Section
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCSwl0-1dnNg5ssenSpxmP2f4gNLJbHsR3332W5z6g6wAp9Dq8VWqbn9oxy6N8EDannzsPlAc14m01tsq13_nJZM86nDlGKdj3z4ZRMJFeur5Z4KT3cGDYaAcO4zoU3eRd0_w5p3SgpsTqsSypLOMSlzmXiwoWpQRqgwdYueVCvISbA_8n1BzIBcOgXRlJugzMZDzna3Ve1GQO9YI4bkwy_TsGlDk1AkaFJsT8Wm2GIU8Fu8TjJJAbxj4ICdWfqyWJFZPBV15-Q8_g',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.blue[900]!.withOpacity(0.6),
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Never miss a beat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'WORLD EXPLORATION AWAITS',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF83fba5).withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF83fba5).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified,
                    color: Color(0xFF006d36),
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Trust Alerts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF005227),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'All notifications are encrypted and sent via secure channels to ensure your travel data stays private.',
                    style: TextStyle(
                      color: const Color(0xFF005227).withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Group: Offers & System
            _buildSectionHeader(
              Icons.star,
              'Offers & Maintenance',
              primaryColor,
              outlineColor,
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              'Promotions & Offers',
              'Exclusive discounts on tours, early-bird access to courses, and seasonal travel deals.',
              _promoOffers,
              (val) => setState(() => _promoOffers = val),
            ),
            const SizedBox(height: 16),
            _buildNotificationToggle(
              'App Updates',
              'Information about new platform releases, performance improvements, and offline map updates.',
              _appUpdates,
              (val) => setState(() => _appUpdates = val),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    IconData icon,
    String title,
    Color primary,
    Color outline,
  ) {
    return Row(
      children: [
        Icon(icon, color: primary, size: 24),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: outline,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0072e5).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF414754),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF005ab7),
          ),
        ],
      ),
    );
  }
}
