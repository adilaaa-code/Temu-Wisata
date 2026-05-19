// ==========================================
// 2. HALAMAN MATERI (LEARN PAGE)
// ==========================================
import 'package:flutter/material.dart';
import 'knowledge_data.dart';
import 'costum_widget.dart';

class LearnPage extends StatefulWidget {
  final Set<String> readMaterials;
  final Function(String) onMaterialRead;
  final Set<String> downloadedMaps;
  final Function(String) onToggleDownload;
  final bool wifiOnly;

  const LearnPage({
    super.key,
    required this.readMaterials,
    required this.onMaterialRead,
    required this.downloadedMaps,
    required this.onToggleDownload,
    required this.wifiOnly,
  });

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  String _selectedLocation = "All";
  String _searchQuery = "";
  final List<String> _locations = [
    "All",
    "JAVA",
    "BALI",
    "SUMATRA",
    "SULAWESI",
    "PAPUA",
    "FLORES",
  ];

  Widget _buildLocationBar() {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _locations.length,
        itemBuilder: (context, index) {
          bool active = _selectedLocation == _locations[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedLocation = _locations[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuint,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? const Color(0xFF005ab7) : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: active
                    ? [
                        BoxShadow(
                          color: const Color(0xFF005ab7).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: active
                      ? Colors.transparent
                      : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Text(
                _locations[index],
                style: TextStyle(
                  color: active ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: buildBlurredAppBar(context, 'Learn History'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBadge(
              'Learning Mode',
              const Color(0xFF006d36),
              const Color(0xFF83fba5).withOpacity(0.3),
              Icons.auto_stories_rounded,
            ),
            const SizedBox(height: 12),
            const Text(
              'Discover Wonders',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const Text(
              'Explore historical and natural marvels.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 32),
            SearchFilterSection(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Explore by Location",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            _buildLocationBar(),
            const SizedBox(height: 32),
            _buildMateriGrid(context),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriGrid(BuildContext context) {
    final List<Map<String, dynamic>> categoryFiltered =
        _selectedLocation == "All"
        ? KnowledgeData.items
        : KnowledgeData.items
              .where((i) => i['location'] == _selectedLocation)
              .toList();

    final List<Map<String, dynamic>> items = categoryFiltered.where((item) {
      final String title = (item['title'] as String).toLowerCase();
      final String location = (item['location'] as String).toLowerCase();
      final String query = _searchQuery.toLowerCase();
      return title.contains(query) || location.contains(query);
    }).toList();

    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 80,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                "tidak ketemu lokasi ini",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 24,
        childAspectRatio: 1.5, // Diubah agar card lebih melebar (landscape)
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final String title = item['title'] as String? ?? "No Title";

        return KnowledgeCard(
          title: title,
          category: item['category'] as String? ?? "",
          location: item['location'] as String? ?? "",
          fact: item['fact'] as String? ?? "",
          imageUrl: item['imageUrl'] as String? ?? "",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationDetailPage(
                  data: item,
                  isRead: widget.readMaterials.contains(title),
                  onRead: () => widget.onMaterialRead(title),
                  isDownloaded: widget.downloadedMaps.contains(title),
                  onToggleDownload: () => widget.onToggleDownload(title),
                  wifiOnly: widget.wifiOnly,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 80,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "No locations or history found",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
