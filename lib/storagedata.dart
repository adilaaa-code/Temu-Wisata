import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'costum_widget.dart';
import 'dart:ui';
import 'dart:io';

class StorageDataPage extends StatefulWidget {
  final XFile? profileImage;
  final Set<String> downloadedMaps;
  final Function(String) onRemoveMap;
  final bool wifiOnly;
  final Function(bool) onWifiChanged;

  const StorageDataPage({
    super.key,
    this.profileImage,
    required this.downloadedMaps,
    required this.onRemoveMap,
    required this.wifiOnly,
    required this.onWifiChanged,
  });

  @override
  State<StorageDataPage> createState() => _StorageDataPageState();
}

class _StorageDataPageState extends State<StorageDataPage> {
  @override
  Widget build(BuildContext context) {
    final int mapCount = widget.downloadedMaps.length;

    // Perhitungan storage dinamis: mulai dari 0, bertambah 0.4 GB per peta
    final double totalGB = 4.0;
    final double usedGB = mapCount * 0.4;
    final double usageRatio = (usedGB / totalGB).clamp(0.0, 1.0);
    final int usagePercentage = (usageRatio * 100).round();

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
                'Storage & Data',
                style: TextStyle(
                  color: Color(0xFF005cbc),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions:
                  const [], // Menghapus ikon profil/tambahan di pojok kanan atas
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        children: [
          // Hero Section
          Container(
            height: 192,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuApcBCRupJWL9vDH2OsqHh8aJonxTRIQIXclXtcuM4ll3MV4e7Mo1RkZtzohrx9ZMc1il3kCrYq0RfRBz7OD4mnlmWibsGw6JxnAJmDwtOqTb63--V8dXMh_HXj6-9OQLtJcIq3PNbiEes9FCyG6LuSluUvA-fCW4cNrNkwVMW81meevhWBOFXDAOqff6CZfsntjP5_uyZj9lp12Bl_TsxcvJ91aimuSRcmi8xjDSIWLo9uBVT4PbvzzCijh8gK3lvzwIimopUOoLk',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF005cbc).withOpacity(0.4),
                        const Color(0xFF006d36).withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Temu Wisata',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Manage your explorer data and map cache.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Progress Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'App Cache',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${usedGB.toStringAsFixed(1)} GB of ${totalGB.toStringAsFixed(1)} GB used',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF83fba5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$usagePercentage% Used',
                        style: const TextStyle(
                          color: Color(0xFF00743a),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Segmented Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 24,
                    child: Row(
                      children: [
                        if (usagePercentage > 0)
                          Expanded(
                            flex: (usagePercentage * 0.7).round(),
                            child: Container(color: const Color(0xFF006d36)),
                          ),
                        if (usagePercentage > 0) const SizedBox(width: 2),
                        if (usagePercentage > 0)
                          Expanded(
                            flex: (usagePercentage * 0.3).round(),
                            child: Container(color: const Color(0xFF66dd8b)),
                          ),
                        if (usagePercentage < 100)
                          Expanded(
                            flex: 100 - usagePercentage,
                            child: Container(color: const Color(0xFFe0e3e5)),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildLegendItem(const Color(0xFF006d36), 'Travel Logs'),
                      const SizedBox(width: 16),
                      _buildLegendItem(const Color(0xFF66dd8b), 'Map Imagery'),
                      const SizedBox(width: 16),
                      _buildLegendItem(const Color(0xFFe0e3e5), 'Available'),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFeceef0)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (widget.downloadedMaps.isEmpty) return;

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Bersihkan Cache?"),
                          content: const Text(
                            "Semua peta offline yang telah diunduh akan dihapus.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                for (var map
                                    in widget.downloadedMaps.toList()) {
                                  widget.onRemoveMap(map);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Hapus Semuanya",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.auto_delete),
                    label: const Text('Clear Cache'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005ab7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      overlayColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Settings List
          _buildSettingRow(
            icon: Icons.wifi,
            iconBg: Colors.blue[100]!,
            iconColor: const Color(0xFF005ab7),
            title: 'Download via Wi-Fi Only',
            subtitle: 'Save mobile data during expeditions',
            trailing: Switch(
              value: widget.wifiOnly,
              onChanged: widget.onWifiChanged,
              activeColor: const Color(0xFF006d36),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Downloaded Regions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (widget.downloadedMaps.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No offline maps downloaded yet.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...widget.downloadedMaps.map(
              (mapName) => _buildSettingRow(
                icon: Icons.map,
                iconBg: const Color(0xFF83fba5),
                iconColor: const Color(0xFF00743a),
                title: mapName,
                subtitle: 'Offline data ready',
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => widget.onRemoveMap(mapName),
                ),
              ),
            ),
          const SizedBox(height: 12),

          // Information Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFf2f4f6),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: const Color(0xFFc1c6d7).withOpacity(0.3),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info, color: Color(0xFF005ab7)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Clearing your cache will not delete your travel milestones or earned certificates. It will only remove temporary images and map tiles to free up space on your device.',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                      color: Color(0xFF414754),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: Color(0xFF414754)),
        ),
      ],
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
