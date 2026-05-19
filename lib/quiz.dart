// ==========================================
// 3. HALAMAN KUIS (QUIZ PAGE)
// ==========================================
import 'package:flutter/material.dart';
import 'dart:ui';
import 'costum_widget.dart';

class QuizPage extends StatefulWidget {
  final VoidCallback onQuizCompleted;
  final VoidCallback? onGoHome;

  const QuizPage({super.key, required this.onQuizCompleted, this.onGoHome});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  bool showResult = false;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizStarted = false; // Tambahkan state untuk mengontrol tampilan awal
  bool _isSelectingLevel = false;
  int _selectedLevel = 1;
  String? _selectedAnswer;
  DateTime? _quizStartTime;
  Duration? _elapsedTime;

  final Map<int, List<Map<String, dynamic>>> _questionsByLevel = {
    1: [
      {
        'question': 'Ibu kota negara Indonesia adalah?',
        'options': ['A. Jakarta', 'B. Bandung', 'C. Surabaya'],
        'correct': 'A',
      },
      {
        'question': 'Pulau yang dijuluki "Pulau Dewata" adalah?',
        'options': ['A. Lombok', 'B. Jawa', 'C. Bali'],
        'correct': 'C',
      },
      {
        'question': 'Candi Buddha terbesar di dunia adalah?',
        'options': ['A. Prambanan', 'B. Borobudur', 'C. Mendut'],
        'correct': 'B',
      },
      {
        'question': 'Monumen Nasional (Monas) terletak di kota?',
        'options': ['A. Bogor', 'B. Jakarta', 'C. Bandung'],
        'correct': 'B',
      },
      {
        'question': 'Makanan khas dari Yogyakarta adalah?',
        'options': ['A. Gudeg', 'B. Rendang', 'C. Pempek'],
        'correct': 'A',
      },
      {
        'question': 'Danau vulkanik terbesar di dunia adalah?',
        'options': ['A. Danau Singkarak', 'B. Danau Kelimutu', 'C. Danau Toba'],
        'correct': 'C',
      },
      {
        'question': 'Hewan Komodo hanya dapat ditemukan di provinsi?',
        'options': ['A. NTT', 'B. Papua', 'C. Bali'],
        'correct': 'A',
      },
      {
        'question': 'Gunung tertinggi di Pulau Jawa adalah?',
        'options': ['A. Merapi', 'B. Semeru', 'C. Bromo'],
        'correct': 'B',
      },
      {
        'question': 'Tari Kecak berasal dari daerah?',
        'options': ['A. Jawa Tengah', 'B. Aceh', 'C. Bali'],
        'correct': 'C',
      },
      {
        'question': 'Suku asli yang mendiami wilayah Papua adalah?',
        'options': ['A. Suku Asmat', 'B. Suku Dayak', 'C. Suku Batak'],
        'correct': 'A',
      },
    ],
    2: [
      {
        'question': 'Dinasti yang membangun Candi Borobudur adalah?',
        'options': ['A. Sanjaya', 'B. Sailendra', 'C. Majapahit'],
        'correct': 'B',
      },
      {
        'question': 'Raja Ampat terletak di provinsi?',
        'options': ['A. Papua Tengah', 'B. Maluku', 'C. Papua Barat'],
        'correct': 'C',
      },
      {
        'question': 'Gunung yang memiliki "Blue Fire" adalah?',
        'options': ['A. Ijen', 'B. Bromo', 'C. Rinjani'],
        'correct': 'A',
      },
      {
        'question': 'Rumah adat Minangkabau disebut?',
        'options': ['A. Joglo', 'B. Rumah Gadang', 'C. Tongkonan'],
        'correct': 'B',
      },
      {
        'question': 'Tari Saman berasal dari provinsi?',
        'options': ['A. Sumatra Utara', 'B. Riau', 'C. Aceh'],
        'correct': 'C',
      },
      {
        'question': 'Candi Hindu terbesar di Indonesia adalah?',
        'options': ['A. Prambanan', 'B. Borobudur', 'C. Kalasan'],
        'correct': 'A',
      },
      {
        'question': 'Danau Kelimutu terkenal karena memiliki?',
        'options': ['A. Air panas', 'B. Tiga warna', 'C. Ikan purba'],
        'correct': 'B',
      },
      {
        'question': 'Wakatobi terletak di wilayah?',
        'options': [
          'A. Sulawesi Utara',
          'B. Sulawesi Selatan',
          'C. Sulawesi Tenggara',
        ],
        'correct': 'C',
      },
      {
        'question': 'Titik Nol Kilometer di ujung barat Indonesia berada di?',
        'options': ['A. Sabang', 'B. Merauke', 'C. Miangas'],
        'correct': 'A',
      },
      {
        'question': 'Jam Gadang adalah ikon kota?',
        'options': ['A. Padang', 'B. Bukittinggi', 'C. Medan'],
        'correct': 'B',
      },
    ],
    3: [
      {
        'question':
            'Suku yang memiliki tradisi pemakaman di tebing batu adalah?',
        'options': ['A. Suku Bugis', 'B. Suku Toraja', 'C. Suku Sasak'],
        'correct': 'B',
      },
      {
        'question': 'Tahun berapakah Raffles menemukan kembali Borobudur?',
        'options': ['A. 1814', 'B. 1811', 'C. 1824'],
        'correct': 'A',
      },
      {
        'question': 'Apa nama pulau di tengah Danau Toba?',
        'options': ['A. Pulau Nias', 'B. Pulau Mansuar', 'C. Pulau Samosir'],
        'correct': 'C',
      },
      {
        'question':
            'Kawah di Dieng yang airnya sering berpindah-pindah adalah?',
        'options': ['A. Kawah Putih', 'B. Kawah Sikidang', 'C. Kawah Upas'],
        'correct': 'B',
      },
      {
        'question': 'Berapa persen spesies karang dunia ada di Raja Ampat?',
        'options': ['A. 75%', 'B. 50%', 'C. 90%'],
        'correct': 'A',
      },
      {
        'question': 'Pantai dengan batu granit raksasa di Belitung adalah?',
        'options': [
          'A. Pantai Kuta',
          'B. Pantai Tanjung Tinggi',
          'C. Pantai Ora',
        ],
        'correct': 'B',
      },
      {
        'question': 'Gunung yang dianggap suci oleh masyarakat Bali adalah?',
        'options': ['A. Gunung Batur', 'B. Gunung Abang', 'C. Gunung Agung'],
        'correct': 'C',
      },
      {
        'question':
            'Pura yang dijuluki sebagai "Mother Temple" di Bali adalah?',
        'options': ['A. Tanah Lot', 'B. Pura Besakih', 'C. Uluwatu'],
        'correct': 'B',
      },
      {
        'question': 'Benteng peninggalan Inggris di Bengkulu bernama?',
        'options': [
          'A. Benteng Marlborough',
          'B. Benteng Vredeburg',
          'C. Benteng Belgica',
        ],
        'correct': 'A',
      },
      {
        'question': 'Danau di Tomohon yang airnya bisa berubah 3 warna adalah?',
        'options': ['A. Danau Toba', 'B. Danau Poso', 'C. Danau Linow'],
        'correct': 'C',
      },
    ],
    4: [
      {
        'question':
            'Apa nama zona Borobudur yang menjelaskan hukum sebab akibat?',
        'options': ['A. Rupadhatu', 'B. Kamadhatu', 'C. Arupadhatu'],
        'correct': 'B',
      },
      {
        'question':
            'Nama danau Kelimutu yang dipercaya tempat jiwa orang jahat?',
        'options': [
          'A. Tiwu Nua Muri',
          'B. Tiwu Ata Mbupu',
          'C. Tiwu Ata Polo',
        ],
        'correct': 'C',
      },
      {
        'question': 'Berapa kedalaman maksimal Danau Toba?',
        'options': ['A. 500m', 'B. 300m', 'C. 700m'],
        'correct': 'A',
      },
      {
        'question': 'Berapa meter tinggi Candi Siwa di kompleks Prambanan?',
        'options': ['A. 37m', 'B. 47m', 'C. 57m'],
        'correct': 'B',
      },
      {
        'question':
            'Tahun berapakah TN Komodo ditetapkan sebagai warisan UNESCO?',
        'options': ['A. 1980', 'B. 2011', 'C. 1991'],
        'correct': 'C',
      },
      {
        'question': 'Siapa tokoh yang membangun Pura Besakih pada abad ke-8?',
        'options': ['A. Rsi Markandeya', 'B. Gajah Mada', 'C. Rakai Pikatan'],
        'correct': 'A',
      },
      {
        'question':
            'Apa nama resor di Maluku yang dijuluki "Maldives Indonesia"?',
        'options': [
          'A. Resor Nihiwatu',
          'B. Pantai Ora',
          'C. Misool Eco Resort',
        ],
        'correct': 'B',
      },
      {
        'question':
            'Suku pengembara laut yang mendiami wilayah Wakatobi adalah?',
        'options': ['A. Suku Bugis', 'B. Suku Buton', 'C. Suku Bajo'],
        'correct': 'C',
      },
      {
        'question': 'Berapa tinggi Gunung Rinjani di Pulau Lombok?',
        'options': ['A. 3.726m', 'B. 3.142m', 'C. 3.676m'],
        'correct': 'A',
      },
      {
        'question': 'Benteng berbentuk segi lima di Banda Neira adalah?',
        'options': [
          'A. Fort de Kock',
          'B. Benteng Belgica',
          'C. Fort Rotterdam',
        ],
        'correct': 'B',
      },
    ],
    5: [
      {
        'question':
            'Letusan supervolcano Toba terjadi sekitar berapa tahun lalu?',
        'options': ['A. 54.000', 'B. 94.000', 'C. 74.000'],
        'correct': 'C',
      },
      {
        'question': 'Nama Sanskerta "Malyabhara" (Malioboro) berarti?',
        'options': [
          'A. Jalan Raya',
          'B. Berhias Karangan Bunga',
          'C. Tempat Berdagang',
        ],
        'correct': 'B',
      },
      {
        'question': 'Dalam Prambanan, Bhuwarloka melambangkan alam untuk?',
        'options': [
          'A. Orang suci & dewa rendah',
          'B. Manusia berdosa',
          'C. Dewa tertinggi',
        ],
        'correct': 'A',
      },
      {
        'question':
            'Berapa jumlah relief Karmawibhangga di kaki Candi Borobudur?',
        'options': ['A. 120', 'B. 160', 'C. 200'],
        'correct': 'B',
      },
      {
        'question': 'Apa nama tempat bersemayam jiwa dalam kepercayaan Toraja?',
        'options': ['A. Nirwana', 'B. Kahyangan', 'C. Puya'],
        'correct': 'C',
      },
      {
        'question': 'Gunung api non-aktif di Bunaken bernama?',
        'options': ['A. Manado Tua', 'B. Lokon', 'C. Mahawu'],
        'correct': 'A',
      },
      {
        'question': 'Ubur-ubur di Danau Kakaban tidak menyengat karena?',
        'options': ['A. Air tawar', 'B. Tidak ada predator', 'C. Suhu air'],
        'correct': 'B',
      },
      {
        'question':
            'Desa Penglipuran dibagi menjadi 3 zona berdasarkan konsep?',
        'options': ['A. Tri Hita Karana', 'B. Tri Dharma', 'C. Tri Mandala'],
        'correct': 'C',
      },
      {
        'question': 'Berapa hektar luas Danau Telaga Warna di Dieng?',
        'options': ['A. 546 hektar', 'B. 340 hektar', 'C. 720 hektar'],
        'correct': 'A',
      },
      {
        'question':
            'Gubernur Inggris yang membangun Benteng Marlborough adalah?',
        'options': [
          'A. Stamford Raffles',
          'B. Joseph Collett',
          'C. Lord Minto',
        ],
        'correct': 'B',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    // Panggil ini agar kuis dimulai dari layar selamat datang setiap kali halaman dibuka
    _goToWelcomeScreen();
  }

  // Fungsi untuk mengecek jawaban dan melanjutkan ke pertanyaan berikutnya
  void _submitAnswer() {
    if (_selectedAnswer ==
        _questionsByLevel[_selectedLevel]![_currentQuestionIndex]['correct']) {
      _score += 10;
    }

    setState(() {
      if (_currentQuestionIndex <
          _questionsByLevel[_selectedLevel]!.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      } else {
        showResult = true;
        _elapsedTime = DateTime.now().difference(_quizStartTime!);
        widget.onQuizCompleted();
      }
    });
  }

  // Fungsi untuk memulai kuis dari awal
  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _isSelectingLevel = true;
      showResult = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _quizStartTime = DateTime.now();
    });
  }

  void _selectLevel(int level) {
    setState(() {
      _selectedLevel = level;
      _isSelectingLevel = false;
      _quizStartTime = DateTime.now();
    });
  }

  // Fungsi untuk kembali ke layar selamat datang (mereset semua)
  void _goToWelcomeScreen() {
    setState(() {
      _quizStarted = false;
      _isSelectingLevel = false;
      showResult = false;
      _currentQuestionIndex = 0;
      _score = 0;
      _selectedAnswer = null;
      _quizStartTime = null;
      _elapsedTime = null;
    });
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return "00m 00s";
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: buildBlurredAppBar(context, 'Interactive Quiz'),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child:
            !_quizStarted // Jika kuis belum dimulai, tampilkan welcome screen
            ? _buildWelcomeView()
            : _isSelectingLevel
            ? _buildLevelSelectionView()
            : (showResult // Jika sudah dimulai, cek apakah hasilnya sudah keluar
                  ? _buildResultView()
                  : _buildQuizView()),
      ),
    );
  }

  // Widget untuk layar selamat datang
  Widget _buildWelcomeView() {
    return Center(
      key: const ValueKey<int>(0), // Key unik untuk AnimatedSwitcher
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.quiz_rounded,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            ),
            const SizedBox(height: 24),
            Text(
              'Selamat datang!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Mari kerjakan kuis tentang tempat wisata yang sudah kamu pelajari. Uji pengetahuanmu sekarang!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _startQuiz, // Panggil fungsi _startQuiz saat tombol ditekan
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: Theme.of(
                    context,
                  ).colorScheme.primary.withOpacity(0.4),
                ),
                child: const Text(
                  'Mulai Kuis',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelSelectionView() {
    return Center(
      key: const ValueKey<int>(1),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Pilih Level Kesulitan',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF005ab7),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tantang dirimu dengan level yang berbeda.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            ...List.generate(5, (index) {
              int level = index + 1;
              String title = "";
              Color color;
              switch (level) {
                case 1:
                  title = "Mudah";
                  color = Colors.green;
                  break;
                case 2:
                  title = "Normal";
                  color = Colors.blue;
                  break;
                case 3:
                  title = "Menengah";
                  color = Colors.orange;
                  break;
                case 4:
                  title = "Sulit";
                  color = Colors.deepOrange;
                  break;
                case 5:
                  title = "Legendaris";
                  color = Colors.red;
                  break;
                default:
                  title = "";
                  color = Colors.grey;
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => _selectLevel(level),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: color.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withOpacity(0.1),
                          child: Text(
                            '$level',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
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
                              const Text(
                                '10 Pertanyaan',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16, color: color),
                      ],
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 120), // Memberikan ruang agar tidak tertutup navbar
          ],
        ),
      ),
    );
  }

  Widget _buildQuizView() {
    final questions = _questionsByLevel[_selectedLevel]!;
    final currentQ = questions[_currentQuestionIndex];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            "Level $_selectedLevel",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF005ab7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Question ${_currentQuestionIndex + 1} of ${questions.length}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          _buildQuestionCard(currentQ['question']),
          const SizedBox(height: 24),
          _quizOption("A", currentQ['options'][0].substring(3)),
          _quizOption("B", currentQ['options'][1].substring(3)),
          _quizOption("C", currentQ['options'][2].substring(3)),
          const SizedBox(height: 40),
          if (_selectedAnswer != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005ab7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFF005ab7).withOpacity(0.4),
                ),
                child: Text(
                  _currentQuestionIndex < questions.length - 1
                      ? 'Next Question'
                      : 'Finish Quiz',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(
            height: 120,
          ), // Memberikan ruang ekstra agar tidak tertutup Navbar
        ],
      ),
    );
  }

  Widget _quizOption(String code, String text) {
    bool isSelected = _selectedAnswer == code;
    return GestureDetector(
      onTap: () => setState(() => _selectedAnswer = code),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF005ab7) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF005ab7).withOpacity(0.3),
                blurRadius: 10,
              ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isSelected ? Colors.white24 : Colors.grey[100],
              child: Text(code),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultView() {
    final questions = _questionsByLevel[_selectedLevel]!;
    int correctCount = _score ~/ 10;
    int wrongCount = questions.length - correctCount;

    return Stack(
      children: [
        // --- Decorative Background Elements ---
        Positioned(
          top: 20,
          left: -30,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF006d36).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF005ab7).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),

        // --- Floating Icons Decor ---
        Positioned(
          top: 100,
          left: 50,
          child: Icon(
            Icons.star,
            color: const Color(0xFFfbbc00).withOpacity(0.4),
            size: 40,
          ),
        ),
        Positioned(
          top: 150,
          right: 40,
          child: Icon(
            Icons.auto_awesome,
            color: const Color(0xFF006d36).withOpacity(0.4),
            size: 30,
          ),
        ),
        Positioned(
          bottom: 200,
          left: 80,
          child: Icon(
            Icons.celebration,
            color: const Color(0xFF005ab7).withOpacity(0.4),
            size: 35,
          ),
        ),

        // --- Main Content Canvas ---
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // --- Glass Result Card ---
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF005ab7).withOpacity(0.15),
                            blurRadius: 32,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF83fba5).withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              size: 48,
                              color: Color(0xFF00743a),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _score >= 80
                                ? 'Hebat, Kamu Seorang Penjelajah Sejati!'
                                : 'Teruslah Belajar!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF005ab7),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Kamu menyelesaikan Level $_selectedLevel.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 32),

                          // --- Score Display ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF005ab7).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0xFF005ab7).withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'SKOR AKHIR',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Color(0xFF005ab7),
                                  ),
                                ),
                                Text(
                                  '$_score/100',
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF005ab7),
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Breakdown Bento Grid ---
                          Row(
                            children: [
                              _buildStatBox(
                                Icons.check_circle,
                                "Benar",
                                "$correctCount Soal",
                                const Color(0xFF006d36),
                              ),
                              const SizedBox(width: 12),
                              _buildStatBox(
                                Icons.cancel,
                                "Salah",
                                "$wrongCount Soal",
                                const Color(0xFFba1a1a),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildStatBox(
                            Icons.timer,
                            "Waktu Pengerjaan",
                            _formatDuration(_elapsedTime),
                            const Color(0xFF765700),
                            fullWidth: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- Action Buttons ---
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _startQuiz,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Coba Lagi"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005ab7),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: widget.onGoHome,
                        icon: const Icon(Icons.home_outlined),
                        label: const Text("Beranda"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          side: const BorderSide(color: Color(0xFF005ab7)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(String q) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        q,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatBox(
    IconData icon,
    String label,
    String value,
    Color color, {
    bool fullWidth = false,
  }) {
    Widget content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return fullWidth ? content : Expanded(child: content);
  }
}
