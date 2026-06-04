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
  bool _isAnswered = false;
  DateTime? _quizStartTime;
  Duration? _elapsedTime;

  final Map<int, List<Map<String, dynamic>>> _questionsByLevel = {
    1: [
      {
        'question': 'Ibu kota negara Indonesia adalah?',
        'options': ['A. Jakarta', 'B. Bandung', 'C. Surabaya'],
        'correct': 'A',
        'explanation': 'Jakarta adalah pusat pemerintahan, ekonomi, dan budaya Indonesia sejak proklamasi kemerdekaan.',
      },
      {
        'question': 'Pulau yang dijuluki "Pulau Dewata" adalah?',
        'options': ['A. Lombok', 'B. Jawa', 'C. Bali'],
        'correct': 'C',
        'explanation': 'Bali dijuluki Pulau Dewata karena keindahan alamnya yang eksotis dan kentalnya tradisi spiritual Hindu.',
      },
      {
        'question': 'Candi Buddha terbesar di dunia adalah?',
        'options': ['A. Prambanan', 'B. Borobudur', 'C. Mendut'],
        'correct': 'B',
        'explanation': 'Borobudur dibangun pada abad ke-9 dan merupakan monumen Buddha terbesar di dunia yang terletak di Jawa Tengah.',
      },
      {
        'question': 'Monumen Nasional (Monas) terletak di kota?',
        'options': ['A. Bogor', 'B. Jakarta', 'C. Bandung'],
        'correct': 'B',
        'explanation': 'Monas berdiri di tengah Lapangan Merdeka, Jakarta Pusat, sebagai lambang perjuangan bangsa Indonesia.',
      },
      {
        'question': 'Makanan khas dari Yogyakarta adalah?',
        'options': ['A. Gudeg', 'B. Rendang', 'C. Pempek'],
        'correct': 'A',
        'explanation': 'Gudeg adalah makanan berbahan nangka muda yang dimasak santan dengan rasa manis khas Yogyakarta.',
      },
      {
        'question': 'Danau vulkanik terbesar di dunia adalah?',
        'options': ['A. Danau Singkarak', 'B. Danau Kelimutu', 'C. Danau Toba'],
        'correct': 'C',
        'explanation': 'Danau Toba terbentuk dari letusan dahsyat gunung api purba sekitar 74.000 tahun yang lalu.',
      },
      {
        'question': 'Hewan Komodo hanya dapat ditemukan di provinsi?',
        'options': ['A. NTT', 'B. Papua', 'C. Bali'],
        'correct': 'A',
        'explanation': 'Komodo adalah spesies kadal terbesar yang hidup di Pulau Komodo, Rinca, dan Flores, NTT.',
      },
      {
        'question': 'Gunung tertinggi di Pulau Jawa adalah?',
        'options': ['A. Merapi', 'B. Semeru', 'C. Bromo'],
        'correct': 'B',
        'explanation': 'Gunung Semeru memiliki puncak bernama Mahameru dengan ketinggian 3.676 meter di atas permukaan laut.',
      },
      {
        'question': 'Tari Kecak berasal dari daerah?',
        'options': ['A. Jawa Tengah', 'B. Aceh', 'C. Bali'],
        'correct': 'C',
        'explanation': 'Tari Kecak adalah seni pertunjukan drama tari yang menceritakan kisah Ramayana dari Bali.',
      },
      {
        'question': 'Suku asli yang mendiami wilayah Papua adalah?',
        'options': ['A. Suku Asmat', 'B. Suku Dayak', 'C. Suku Batak'],
        'correct': 'A',
        'explanation': 'Suku Asmat dikenal dengan seni ukiran kayunya yang unik dan merupakan salah satu suku terbesar di Papua.',
      },
    ],
    2: [
      {
        'question': 'Dinasti yang membangun Candi Borobudur adalah?',
        'options': ['A. Sanjaya', 'B. Sailendra', 'C. Majapahit'],
        'correct': 'B',
        'explanation': 'Dinasti Sailendra membangun Borobudur sebagai tempat ziarah dan pemujaan Buddha pada masa kejayaannya.',
      },
      {
        'question': 'Raja Ampat terletak di provinsi?',
        'options': ['A. Papua Tengah', 'B. Maluku', 'C. Papua Barat'],
        'correct': 'C',
        'explanation': 'Raja Ampat berada di Papua Barat Daya dan dikenal sebagai pusat keanekaragaman hayati laut terkaya di dunia.',
      },
      {
        'question': 'Gunung yang memiliki "Blue Fire" adalah?',
        'options': ['A. Ijen', 'B. Bromo', 'C. Rinjani'],
        'correct': 'A',
        'explanation': 'Api Biru di Kawah Ijen terbentuk dari reaksi gas belerang yang terbakar saat bersentuhan dengan udara.',
      },
      {
        'question': 'Rumah adat Minangkabau disebut?',
        'options': ['A. Joglo', 'B. Rumah Gadang', 'C. Tongkonan'],
        'correct': 'B',
        'explanation': 'Rumah Gadang memiliki atap berbentuk gonjong yang melambangkan tanduk kerbau atau kapal.',
      },
      {
        'question': 'Tari Saman berasal dari provinsi?',
        'options': ['A. Sumatra Utara', 'B. Riau', 'C. Aceh'],
        'correct': 'C',
        'explanation': 'Tari Saman merupakan warisan budaya dunia UNESCO yang ditarikan dalam formasi baris yang rapat dan ritme cepat.',
      },
      {
        'question': 'Candi Hindu terbesar di Indonesia adalah?',
        'options': ['A. Prambanan', 'B. Borobudur', 'C. Kalasan'],
        'correct': 'A',
        'explanation': 'Prambanan adalah candi Hindu yang dibangun pada abad ke-9 sebagai persembahan untuk Dewa Siwa.',
      },
      {
        'question': 'Danau Kelimutu terkenal karena memiliki?',
        'options': ['A. Air panas', 'B. Tiga warna', 'C. Ikan purba'],
        'correct': 'B',
        'explanation': 'Danau ini memiliki tiga kawah dengan warna yang berubah-ubah secara periodik karena kandungan mineralnya.',
      },
      {
        'question': 'Wakatobi terletak di wilayah?',
        'options': [
          'A. Sulawesi Utara',
          'B. Sulawesi Selatan',
          'C. Sulawesi Tenggara',
        ],
        'correct': 'C',
        'explanation': 'Wakatobi adalah akronim dari empat pulau besar: Wangi-wangi, Kaledupa, Tomia, dan Binongko di Sulawesi Tenggara.',
      },
      {
        'question': 'Titik Nol Kilometer di ujung barat Indonesia berada di?',
        'options': ['A. Sabang', 'B. Merauke', 'C. Miangas'],
        'correct': 'A',
        'explanation': 'Tugu Nol Kilometer terletak di Pulau Weh, Sabang, menandai batas paling barat nusantara.',
      },
      {
        'question': 'Jam Gadang adalah ikon kota?',
        'options': ['A. Padang', 'B. Bukittinggi', 'C. Medan'],
        'correct': 'B',
        'explanation': 'Jam Gadang dibangun pada tahun 1926 dan memiliki keunikan pada penulisan angka romawi 4 yaitu IIII.',
      },
    ],
    3: [
      {
        'question':
            'Suku yang memiliki tradisi pemakaman di tebing batu adalah?',
        'options': ['A. Suku Bugis', 'B. Suku Toraja', 'C. Suku Sasak'],
        'correct': 'B',
        'explanation': 'Suku Toraja di Sulawesi Selatan meletakkan jenazah di liang tebing batu dalam tradisi pemakaman Rambu Solo.',
      },
      {
        'question': 'Tahun berapakah Raffles menemukan kembali Borobudur?',
        'options': ['A. 1814', 'B. 1811', 'C. 1824'],
        'correct': 'A',
        'explanation': 'Sir Thomas Stamford Raffles menginstruksikan pembersihan area Borobudur pada 1814 setelah mendengar laporan warga lokal.',
      },
      {
        'question': 'Apa nama pulau di tengah Danau Toba?',
        'options': ['A. Pulau Nias', 'B. Pulau Mansuar', 'C. Pulau Samosir'],
        'correct': 'C',
        'explanation': 'Pulau Samosir adalah pulau vulkanik besar yang terbentuk di tengah kaldera raksasa Danau Toba.',
      },
      {
        'question':
            'Kawah di Dieng yang airnya sering berpindah-pindah adalah?',
        'options': ['A. Kawah Putih', 'B. Kawah Sikidang', 'C. Kawah Upas'],
        'correct': 'B',
        'explanation': 'Kawah Sikidang dinamakan demikian karena letak kawah utamanya yang sering melompat-lompat seperti kijang.',
      },
      {
        'question': 'Berapa persen spesies karang dunia ada di Raja Ampat?',
        'options': ['A. 75%', 'B. 50%', 'C. 90%'],
        'correct': 'A',
        'explanation': 'Raja Ampat memiliki keanekaragaman karang tertinggi, menyimpan sekitar 75% jenis karang dunia.',
      },
      {
        'question': 'Pantai dengan batu granit raksasa di Belitung adalah?',
        'options': [
          'A. Pantai Kuta',
          'B. Pantai Tanjung Tinggi',
          'C. Pantai Ora',
        ],
        'correct': 'B',
        'explanation': 'Pantai Tanjung Tinggi menjadi ikonik setelah menjadi lokasi syuting film Laskar Pelangi.',
      },
      {
        'question': 'Gunung yang dianggap suci oleh masyarakat Bali adalah?',
        'options': ['A. Gunung Batur', 'B. Gunung Abang', 'C. Gunung Agung'],
        'correct': 'C',
        'explanation': 'Gunung Agung adalah gunung tertinggi di Bali dan dianggap sebagai pusat spiritual jagat raya.',
      },
      {
        'question':
            'Pura yang dijuluki sebagai "Mother Temple" di Bali adalah?',
        'options': ['A. Tanah Lot', 'B. Pura Besakih', 'C. Uluwatu'],
        'correct': 'B',
        'explanation': 'Pura Besakih adalah kompleks pura terbesar dan tersuci yang terletak di lereng Gunung Agung.',
      },
      {
        'question': 'Benteng peninggalan Inggris di Bengkulu bernama?',
        'options': [
          'A. Benteng Marlborough',
          'B. Benteng Vredeburg',
          'C. Benteng Belgica',
        ],
        'correct': 'A',
        'explanation': 'Fort Marlborough adalah benteng terkuat Inggris di wilayah Timur yang dibangun oleh EIC pada tahun 1714.',
      },
      {
        'question': 'Danau di Tomohon yang airnya bisa berubah 3 warna adalah?',
        'options': ['A. Danau Toba', 'B. Danau Poso', 'C. Danau Linow'],
        'correct': 'C',
        'explanation': 'Warna air Danau Linow berubah karena kadar belerang yang tinggi yang bereaksi dengan sinar matahari.',
      },
    ],
    4: [
      {
        'question':
            'Apa nama zona Borobudur yang menjelaskan hukum sebab akibat?',
        'options': ['A. Rupadhatu', 'B. Kamadhatu', 'C. Arupadhatu'],
        'correct': 'B',
        'explanation': 'Kamadhatu adalah bagian dasar Borobudur yang berisi 160 relief tentang hukum sebab-akibat (Karma).',
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
        'explanation': 'Tiwu Ata Polo adalah salah satu dari tiga danau yang seringkali berwarna merah gelap.',
      },
      {
        'question': 'Berapa kedalaman maksimal Danau Toba?',
        'options': ['A. 500m', 'B. 300m', 'C. 700m'],
        'correct': 'A',
        'explanation': 'Danau Toba memiliki kedalaman mencapai lebih dari 500 meter, menjadikannya salah satu danau terdalam di dunia.',
      },
      {
        'question': 'Berapa meter tinggi Candi Siwa di kompleks Prambanan?',
        'options': ['A. 37m', 'B. 47m', 'C. 57m'],
        'correct': 'B',
        'explanation': 'Candi Siwa adalah bangunan utama yang menjulang setinggi 47 meter di pusat kompleks Prambanan.',
      },
      {
        'question':
            'Tahun berapakah TN Komodo ditetapkan sebagai warisan UNESCO?',
        'options': ['A. 1980', 'B. 2011', 'C. 1991'],
        'correct': 'C',
        'explanation': 'Taman Nasional Komodo diakui UNESCO pada 1991 untuk melindungi Komodo dan habitat uniknya.',
      },
      {
        'question': 'Siapa tokoh yang membangun Pura Besakih pada abad ke-8?',
        'options': ['A. Rsi Markandeya', 'B. Gajah Mada', 'C. Rakai Pikatan'],
        'correct': 'A',
        'explanation': 'Rsi Markandeya, seorang pemuka agama Hindu dari Jawa, mendirikan cikal bakal Pura Besakih.',
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
        'explanation': 'Pantai Ora di Pulau Seram memiliki resor terapung di atas air laut yang sangat jernih dan tenang.',
      },
      {
        'question':
            'Suku pengembara laut yang mendiami wilayah Wakatobi adalah?',
        'options': ['A. Suku Bugis', 'B. Suku Buton', 'C. Suku Bajo'],
        'correct': 'C',
        'explanation': 'Suku Bajo dikenal sebagai kaum pengembara laut yang memiliki kemampuan menyelam luar biasa.',
      },
      {
        'question': 'Berapa tinggi Gunung Rinjani di Pulau Lombok?',
        'options': ['A. 3.726m', 'B. 3.142m', 'C. 3.676m'],
        'correct': 'A',
        'explanation': 'Rinjani adalah gunung berapi tertinggi kedua di Indonesia dengan ketinggian 3.726 mdpl.',
      },
      {
        'question': 'Benteng berbentuk segi lima di Banda Neira adalah?',
        'options': [
          'A. Fort de Kock',
          'B. Benteng Belgica',
          'C. Fort Rotterdam',
        ],
        'correct': 'B',
        'explanation': 'Benteng Belgica dibangun oleh VOC pada abad ke-17 untuk mengawasi perdagangan pala di Kepulauan Banda.',
      },
    ],
    5: [
      {
        'question':
            'Letusan supervolcano Toba terjadi sekitar berapa tahun lalu?',
        'options': ['A. 54.000', 'B. 94.000', 'C. 74.000'],
        'correct': 'C',
        'explanation': 'Letusan dahsyat Toba 74.000 tahun lalu hampir memusnahkan sebagian besar umat manusia pada saat itu.',
      },
      {
        'question': 'Nama Sanskerta "Malyabhara" (Malioboro) berarti?',
        'options': [
          'A. Jalan Raya',
          'B. Berhias Karangan Bunga',
          'C. Tempat Berdagang',
        ],
        'correct': 'B',
        'explanation': 'Malioboro dulunya merupakan jalan yang dihias bunga saat upacara penyambutan tamu kerajaan.',
      },
      {
        'question': 'Dalam Prambanan, Bhuwarloka melambangkan alam untuk?',
        'options': [
          'A. Orang suci & dewa rendah',
          'B. Manusia berdosa',
          'C. Dewa tertinggi',
        ],
        'correct': 'A',
        'explanation': 'Bhuwarloka adalah alam antara (tengah), tempat bagi mereka yang sudah mulai terlepas dari nafsu duniawi.',
      },
      {
        'question':
            'Berapa jumlah relief Karmawibhangga di kaki Candi Borobudur?',
        'options': ['A. 120', 'B. 160', 'C. 200'],
        'correct': 'B',
        'explanation': 'Terdapat 160 relief Karmawibhangga yang saat ini sebagian besar tertutup oleh kaki candi tambahan.',
      },
      {
        'question': 'Apa nama tempat bersemayam jiwa dalam kepercayaan Toraja?',
        'options': ['A. Nirwana', 'B. Kahyangan', 'C. Puya'],
        'correct': 'C',
        'explanation': 'Puya adalah dunia arwah dalam kepercayaan asli masyarakat Toraja (Aluk To Dolo).',
      },
      {
        'question': 'Gunung api non-aktif di Bunaken bernama?',
        'options': ['A. Manado Tua', 'B. Lokon', 'C. Mahawu'],
        'correct': 'A',
        'explanation': 'Pulau Manado Tua merupakan bekas gunung berapi yang memberikan kontribusi geologis bagi ekosistem laut Bunaken.',
      },
      {
        'question': 'Ubur-ubur di Danau Kakaban tidak menyengat karena?',
        'options': ['A. Air tawar', 'B. Tidak ada predator', 'C. Suhu air'],
        'correct': 'B',
        'explanation': 'Karena terisolasi ribuan tahun tanpa predator, ubur-ubur di sana kehilangan kemampuan menyengat untuk bertahan hidup.',
      },
      {
        'question':
            'Desa Penglipuran dibagi menjadi 3 zona berdasarkan konsep?',
        'options': ['A. Tri Hita Karana', 'B. Tri Dharma', 'C. Tri Mandala'],
        'correct': 'C',
        'explanation': 'Tri Mandala membagi desa menjadi Utama Mandala (suci), Madya Mandala (hunian), dan Nista Mandala (pemakaman/luar).',
      },
      {
        'question': 'Berapa hektar luas Danau Telaga Warna di Dieng?',
        'options': ['A. 546 hektar', 'B. 340 hektar', 'C. 720 hektar'],
        'correct': 'A',
        'explanation': 'Luas keseluruhan danau ini mencakup area vulkanik yang kaya akan deposit mineral belerang.',
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
        'explanation': 'Joseph Collett menjabat sebagai gubernur di Bengkulu saat pembangunan awal benteng ini pada 1714.',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    // Panggil ini agar kuis dimulai dari layar selamat datang setiap kali halaman dibuka
    _goToWelcomeScreen();
  }

  void _onAnswerSelected(String code) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = code;
      _isAnswered = true;
      if (code ==
          _questionsByLevel[_selectedLevel]![_currentQuestionIndex]['correct']) {
        _score += 10;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentQuestionIndex <
          _questionsByLevel[_selectedLevel]!.length - 1) {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _isAnswered = false;
      } else {
        showResult = true;
        _elapsedTime = DateTime.now().difference(_quizStartTime!);
        widget.onQuizCompleted();
      }
      _quizStartTime = DateTime.now(); // Reset timer untuk soal berikutnya
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
      _isAnswered = false;
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
      _isAnswered = false;
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
          _quizOption("A", currentQ['options'][0].substring(3), currentQ['correct']),
          _quizOption("B", currentQ['options'][1].substring(3), currentQ['correct']),
          _quizOption("C", currentQ['options'][2].substring(3), currentQ['correct']),
          if (_isAnswered) ...[
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 10 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF005ab7).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF005ab7).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Penjelasan:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005ab7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(currentQ['explanation'] ?? ""),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 40),
          if (_isAnswered)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _nextQuestion,
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
                      ? 'Lanjut ke Soal Berikutnya'
                      : 'Selesaikan Kuis',
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

  Widget _quizOption(String code, String text, String correct) {
    bool isSelected = _selectedAnswer == code;
    Color bgColor = Colors.white;
    Color textColor = Colors.black;

    if (_isAnswered) {
      if (code == correct) {
        bgColor = const Color(0xFF006d36); // Hijau untuk yang benar
        textColor = Colors.white;
      } else if (isSelected) {
        bgColor = const Color(0xFFba1a1a); // Merah untuk pilihan salah
        textColor = Colors.white;
      }
    } else if (isSelected) {
      bgColor = const Color(0xFF005ab7);
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: () => _onAnswerSelected(code),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (isSelected)
              BoxShadow(color: bgColor.withOpacity(0.3), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: textColor.withOpacity(0.1),
              child: Text(code),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
