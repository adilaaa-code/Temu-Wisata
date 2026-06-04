// ==========================================
// 1. HALAMAN DASHBOARD (DESAIN BARU)
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'costum_widget.dart';
import 'knowledge_data.dart';

class DashboardPage extends StatefulWidget {
  final VoidCallback onStartLearning;
  final VoidCallback onTakeQuiz;
  final XFile? profileImage;
  final double dailyProgress;
  final Set<String> readMaterials;
  final Function(String) onMaterialRead;
  final Set<String> downloadedMaps;
  final Function(String) onToggleDownload;
  final bool wifiOnly;

  const DashboardPage({
    super.key,
    required this.onStartLearning,
    required this.onTakeQuiz,
    this.profileImage,
    required this.dailyProgress,
    required this.readMaterials,
    required this.onMaterialRead,
    required this.downloadedMaps,
    required this.onToggleDownload,
    required this.wifiOnly,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ScrollController _scrollController;
  Timer? _timer;
  late List<Map<String, dynamic>> _cachedItems;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _prepareData();
    // Memulai auto-scroll setelah frame pertama selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _prepareData() {
    _cachedItems = KnowledgeData.items.map((item) {
      Color accent;
      switch (item['category']) {
        case 'HISTORY':
          accent = const Color(0xFF005ab7);
          break;
        case 'NATURE':
          accent = const Color(0xFF006d36);
          break;
        case 'CULTURAL':
          accent = const Color(0xFF765700);
          break;
        case 'BEACH':
          accent = const Color(0xFF005ab7);
          break;
        default:
          accent = const Color(0xFF005ab7);
      }
      return {
        ...item,
        'accentColor': accent,
        'displaySubtitle': item['location'] ?? 'Indonesia',
      };
    }).toList();
  }

  void _startAutoScroll() {
    // Timer setiap 4 detik agar user punya waktu melihat konten
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_scrollController.hasClients) {
        double scrollStep = 300.0; // Lebar kartu + margin
        double nextOffset = _scrollController.offset + scrollStep;

        _scrollController.animateTo(
          nextOffset,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic, // Kurva yang lebih ringan untuk performa
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,

      // --- AppBar (Glassmorphism) ---
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
              title: const Text(
                'Temu Wisata',
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 100.0,
        ), // Memberikan jarak agar di atas navbar
        child: FloatingActionButton(
          onPressed: () => _showGeminiChat(context),
          backgroundColor: const Color(0xFF005ab7),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 40),
          // Animasi Fade In untuk Hero Section
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: DiscoverHeroSection(
              onStartLearning: widget.onStartLearning,
              onTakeQuiz: widget.onTakeQuiz,
            ),
          ),
          const SizedBox(height: 40),

          // --- Recommended Destinations ---
          const SectionHeader(
            title: 'Recommended',
            subtitle: 'Based on your travel history',
          ),
          const SizedBox(height: 16),

          RepaintBoundary(
            child: SizedBox(
              height: 380,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                // Mengurangi beban komputasi saat scrolling
                addRepaintBoundaries: true,
                addAutomaticKeepAlives: false,
                // Gunakan jumlah item yang besar namun terbatas untuk optimasi list
                itemCount: 10000,
                itemBuilder: (context, index) {
                  if (_cachedItems.isEmpty) return const SizedBox();
                  final dest = _cachedItems[index % _cachedItems.length];
                  final String title = dest['title'] ?? "";

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        createSmoothRoute(
                          DestinationDetailPage(
                            data: dest,
                            isRead: widget.readMaterials.contains(title),
                            onRead: () => widget.onMaterialRead(title),
                            isDownloaded: widget.downloadedMaps.contains(title),
                            onToggleDownload: () =>
                                widget.onToggleDownload(title),
                            wifiOnly: widget.wifiOnly,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      tag: dest['title'] ?? '',
                      child: DestinationCard(
                        title: dest['title'] ?? '',
                        category: dest['category'] ?? '',
                        time: dest['displaySubtitle'] ?? '',
                        imageUrl: dest['imageUrl'] ?? '',
                        accentColor: dest['accentColor'] ?? Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),

          // --- Daily Progress ---
          DailyProgressCard(progress: widget.dailyProgress),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _showGeminiChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _GeminiChatSheet(profileImage: widget.profileImage),
    );
  }
}

class _GeminiChatSheet extends StatefulWidget {
  final XFile? profileImage;
  const _GeminiChatSheet({this.profileImage});

  @override
  State<_GeminiChatSheet> createState() => _GeminiChatSheetState();
}

class _GeminiChatSheetState extends State<_GeminiChatSheet> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'ai',
      'message':
          'Halo! Saya asisten AI Temu Wisata. Ada yang bisa saya bantu seputar destinasi di Indonesia?',
    },
  ];
  bool _isTyping = false;

  // Masukkan API Key yang Anda dapatkan dari https://aistudio.google.com/
  // Perhatian: Jangan membagikan Key ini atau mempublikasikannya ke repositori publik!
  // PENTING: Jika error berlanjut, hapus key lama di Google AI Studio dan buat yang baru.
  // TIPS: Jika --dart-define sulit, hapus String.fromEnvironment(...) dan ganti langsung dengan 'AIzaSy...'

  // Menggunakan String.fromEnvironment adalah cara paling aman agar API Key tidak masuk ke GitHub.
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  GenerativeModel? _model;
  ChatSession? _chatSession;

  @override
  void initState() {
    super.initState();
    _initializeGemini();
  }

  void _initializeGemini() {
    if (_apiKey.isNotEmpty) {
      try {
        _model = GenerativeModel(
          model: 'gemini-2.5-flash', // Menggunakan versi 2.0 yang stabil
          apiKey: _apiKey,
          systemInstruction: Content.system(
            'Kamu adalah asisten AI ramah untuk aplikasi "Temu Wisata". Tugasmu membantu pengguna menjawab pertanyaan seputar pariwisata Indonesia, budaya, sejarah, dan fitur aplikasi (Learn, Quiz, Peta Offline). Gunakan bahasa Indonesia yang santun.',
          ),
        );
        _chatSession = _model!.startChat();
        debugPrint('Gemini: Sesi chat berhasil dimulai.');
      } catch (e) {
        // Menampilkan error detail saat inisialisasi
        debugPrint('Gemini: Gagal inisialisasi model: $e');
      }
    } else {
      debugPrint(
        'Gemini: API Key kosong. Gunakan --dart-define atau hardcode di variabel _apiKey.',
      );
    }
  }

  Future<void> _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    // Pastikan model terinisialisasi
    if (_model == null) _initializeGemini();

    // Cek apakah API Key sudah terisi
    if (_apiKey.isEmpty) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'message':
              '⚠️ API Key Gemini belum terpasang.\n\n'
              'Untuk menjalankan fitur ini, gunakan perintah:\n'
              'flutter run --dart-define=GEMINI_API_KEY=AIzaSyA...\n\n'
              'Atau gunakan file .vscode/launch.json.',
        });
      });
      _controller.clear();
      return;
    }

    setState(() {
      _messages.add({'role': 'user', 'message': userMessage});
      _isTyping = true;
      _controller.clear();
    });

    if (_chatSession == null) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'message': 'Gagal memulai percakapan. Pastikan API Key sudah benar.',
        });
        _isTyping = false;
      });
      return;
    }

    try {
      final response = await _chatSession!.sendMessage(
        Content.text(userMessage),
      );

      // Tambahkan log untuk melihat response sukses di konsol
      debugPrint('Gemini Response: ${response.text}');

      setState(() {
        _messages.add({
          'role': 'ai',
          'message': response.text ?? 'Maaf, saya tidak mengerti.',
        });
      });
    } catch (e) {
      debugPrint('Gemini Error Detail: $e');

      String errorMessage = 'Maaf, terjadi kesalahan: ${e.toString()}';

      if (e.toString().contains('API_KEY_INVALID') ||
          e.toString().contains('invalid api key')) {
        errorMessage =
            'API Key tidak valid. Silakan buat Key baru di Google AI Studio.';
      } else if (e.toString().contains('User location is not supported')) {
        errorMessage =
            'Gemini API belum tersedia di wilayah Anda atau gunakan VPN.';
      } else if (e.toString().contains('429')) {
        errorMessage = 'Kuota API habis. Silakan tunggu beberapa saat.';
      } else if (e.toString().contains('SAFETY')) {
        errorMessage = 'Pertanyaan Anda diblokir oleh filter keamanan AI.';
      }

      setState(() {
        _messages.add({'role': 'ai', 'message': errorMessage});
      });
    } finally {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    // Jika keyboard muncul, kita ikuti tinggi keyboard.
    // Jika tidak, kita beri jarak 110px agar berada di atas floating navbar.
    final double bottomMargin = keyboardHeight > 0 ? keyboardHeight + 16 : 110;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      margin: EdgeInsets.fromLTRB(16, 0, 16, bottomMargin),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tanya AI Temu Wisata',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color(0xFF005ab7)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20).copyWith(
                        bottomRight: isUser
                            ? Radius.zero
                            : const Radius.circular(20),
                        bottomLeft: isUser
                            ? const Radius.circular(20)
                            : Radius.zero,
                      ),
                    ),
                    child: Text(
                      msg['message']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Tanya sesuatu...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF005ab7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String title, category, time, imageUrl;
  final Color accentColor;

  const DestinationCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.imageUrl,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 600, // Optimasi: Limit resolusi gambar di memori
                  cacheHeight: 400,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        time,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
