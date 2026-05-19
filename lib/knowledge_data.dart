import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'costum_widget.dart'; // Import the helper function
// ==========================================
// 1. CLASS UI: DESTINATION DETAIL PAGE
// ==========================================
class DestinationDetailPage extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isRead;
  final VoidCallback onRead;
  final bool isDownloaded;
  final VoidCallback onToggleDownload;
  final bool wifiOnly;

  const DestinationDetailPage({
    super.key,
    required this.data,
    required this.isRead,
    required this.onRead,
    required this.isDownloaded,
    required this.onToggleDownload,
    required this.wifiOnly,
  });

  // Fungsi untuk membuka Google Maps [cite: 3]
  static Future<void> _openMap(BuildContext context, String locationName) async {
    if (locationName.isEmpty) return;

    final String query = Uri.encodeComponent(locationName);
    final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$query");

    // Langsung mencoba membuka URL tanpa canLaunchUrl karena masalah visibilitas paket di Android 11+
    // Menggunakan LaunchMode.externalApplication akan memaksa sistem mencari aplikasi yang cocok (Maps/Browser)
    final bool launched = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka peta. Pastikan browser atau Google Maps tersedia.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header dengan gambar yang bisa menyusut [cite: 5]
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            stretch: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black26,
                child: const BackButton(color: Colors.white),
              ),
            ),
            backgroundColor: const Color(0xFF005ab7),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                data['title'] ?? "Detail",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black45)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: data['title'] ?? '',
                    child: Image(
                      image: ResizeImage(
                        getImageProvider(data['imageUrl'] as String?),
                        // Batasi resolusi decode untuk menghemat RAM & GPU
                        width: 1000, 
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tombol Lokasi [cite: 6]
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openMap(context, data['title'] ?? ""),
                      borderRadius: BorderRadius.circular(15),
                      splashColor: const Color(0xFF005ab7).withOpacity(0.1),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFF005ab7)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['location'] ?? "Unknown Location",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                const Text("Lihat di Google Maps",
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  ),
                  const SizedBox(height: 12),
                  // Tombol Download Offline Map
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                      if (!isDownloaded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(wifiOnly 
                              ? 'Mengunduh peta via Wi-Fi...' 
                              : 'Mengunduh peta via Data Seluler...'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                      onToggleDownload();
                    },
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDownloaded 
                            ? const Color(0xFF006d36).withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isDownloaded 
                              ? const Color(0xFF006d36).withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3)
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isDownloaded ? Icons.cloud_done : Icons.cloud_download_outlined, 
                            color: isDownloaded ? const Color(0xFF006d36) : Colors.grey
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isDownloaded ? "Peta Offline Tersedia" : "Download Peta Offline",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDownloaded ? const Color(0xFF006d36) : Colors.black87
                                  ),
                                ),
                                Text(
                                  isDownloaded ? "Peta dapat diakses tanpa internet" : "Gunakan Wi-Fi atau Data Seluler",
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          if (isDownloaded)
                            const Icon(Icons.check_circle, size: 18, color: Color(0xFF006d36)),
                        ],
                      ),
                    ),
                  ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(Icons.lightbulb_outline, "Fun Fact"),
                  const SizedBox(height: 12),
                  SelectableText(
                    data['fact'] ?? "",
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle(Icons.description_outlined, "Deskripsi Lengkap"),
                  const SizedBox(height: 12),
                  SelectableText(
                    data['description'] ?? "",
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 40),
                  // Tombol Mark as Read [cite: 8]
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: isRead
                          ? null
                          : () {
                              onRead();
                              Navigator.pop(context);
                            },
                      icon: Icon(isRead ? Icons.check_circle : Icons.bookmark_add_outlined),
                      label: Text(
                        isRead ? "Sudah Dipelajari" : "Tandai Sudah Dibaca",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005ab7),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[300],
                        disabledForegroundColor: Colors.grey[600],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF005ab7), size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1a1a1a),
          ),
        ),
      ],
    );
  }
}

class KnowledgeData {
  static final List<Map<String, dynamic>> items = [
    {
      'title': 'Borobudur Temple',
      'category': 'CULTURAL',
      'location': 'JAVA',
      'fact': 'World\'s largest Buddhist temple.',
      'imageUrl': 'assets/Borobudur.jpg',
      'description': '''Sejarah Candi Borobudur
Candi Borobudur adalah salah satu monumen Buddha terbesar dan paling megah di dunia. Dikenal sebagai simbol kejayaan arsitektur dan seni budaya dari masa lalu, Candi Borobudur memiliki sejarah yang kaya dan mendalam yang tercermin dalam setiap batu dan reliefnya.

Asal Usul Pembangunan
Dinasti Sailendra membangun peninggalan Budha terbesar di dunia antara 780-840 Masehi. Dinasti Sailendra merupakan dinasti yang berkuasa pada masa itu. Peninggalan ini dibangun sebagai tempat pemujaan Budha dan tempat ziarah. Tempat ini berisi petunjuk agar manusia menjauhkan diri dari nafsu dunia dan menuju pencerahan dan kebijaksanaan menurut Buddha. Peninggalan ini ditemukan oleh Pasukan Inggris pada tahun 1814 dibawah pimpinan Sir Thomas Stanford Raffles. Area candi berhasil dibersihkan seluruhnya pada tahun 1835.

Borobudur dibangun dengan gaya Mandala yang mencerminkan alam semesta dalam kepercayaan Buddha. Struktur bangunan ini berbentuk kotak dengan empat pintu masuk dan titik pusat berbentuk lingkaran. Jika dilihat dari luar hingga ke dalam terbagi menjadi dua bagian yaitu alam dunia yang terbagi menjadi tiga zona di bagian luar, dan alam Nirwana di bagian pusat.

Zona 1 : Kamadhatu
Alam dunia yang terlihat dan sedang dialami oleh manusia sekarang. Kamadhatu terdiri dari 160 relief yang menjelaskan Karmawibhangga Sutra, yaitu hukum sebab akibat. Menggambarkan mengenai sifat dan nafsu manusia, seperti merampok, membunuh, membunuh, penyiksaan, dan fitnah.

Zona 2 : Rupadhatu
Alam peralihan, dimana manusia telah dibebaskan dari urusan dunia. Rapadhatu terdiri dari galeri ukiran relief batu dan patung buddha. Secara keseluruhan ada 328 patung Buddha yang juga memiliki hiasan relief pada ukirannya. Terdiri dari 1300 relief yang berupa Gandhawyuha, Lalitawistara, Jataka dan Awadana.

Zona 3 : Arupadhatu
Alam tertinggi, rumah Tuhan. Tiga serambi berbentuk lingkaran mengarah ke kubah di bagian pusat atau stupa yang menggambarkan kebangkitan dari dunia. Pada bagian ini tidak ada ornamen maupun hiasan, yang berarti menggambarkan kemurnian tertinggi. Terdapat 72 stupa secara keseluruhan yang mengelilingi stupa pusat.

Relief
Secara keseluruhan terdapat 504 Buddha dengan sikap meditasi dan enam posisi tangan yang berbeda di sepanjang candi.

Koridor Candi
Selama restorasi pada awal abad ke 20, ditemukan dua candi yang lebih kecil di sekitar Borobudur, yaitu Candi Pawon dan Candi Mendut yang segaris dengan Candi Borobudur. Candi Pawon berada 1.15 km dari Borobudur, sementara Candi Mendut berada 3 km dari Candi Borobudur.

Ketiga candi membentuk rute untuk Festival Hari Waisak yag digelar tiap tahun saat bulan purnama pada Bulan April atau Mei. Festival tersebut sebagai peringatan atas lahir dan meninggalnya, serta pencerahan yang diberikan oleh Buddha Gautama.

Nikmati pengalaman berkunjung di Candi Borobudur secara langsung digenggamanmu!''',
    },
    {
      'title': 'Raja Ampat',
      'category': 'NATURE',
      'location': 'PAPUA',
      'fact': '75% of known coral species.',
      'imageUrl': 'assets/Raja_Ampat.jpg',
      'description': '''Pesona Wisata Raja Ampat
Raja Ampat adalah salah satu surga tropis paling menakjubkan dan menjadi jantung keanekaragaman hayati laut dunia. Dikenal sebagai permata di ujung timur Indonesia, Raja Ampat menawarkan keindahan alam yang tak tertandingi, mencerminkan kemegahan ekosistem laut yang masih terjaga keasliannya di setiap sudut gugusan pulaunya.

Asal Usul Nama
Nama Raja Ampat berasal dari mitos lokal masyarakat setempat yang menceritakan tentang seorang wanita yang menemukan tujuh buah telur. Empat di antaranya menetas menjadi pangeran yang kemudian menjadi raja yang berkuasa di empat pulau besar, yaitu Waigeo, Misool, Salawati, dan Batanta. Itulah sebabnya wilayah ini dinamakan "Raja Ampat" atau Empat Raja. Kepulauan ini mulai dikenal luas oleh dunia internasional pada awal tahun 1990-an setelah seorang penyelam asal Belanda melakukan ekspedisi dan menemukan kekayaan bawah laut yang luar biasa.

Raja Ampat terletak di "Segitiga Terumbu Karang Dunia" yang memiliki konsentrasi spesies laut tertinggi di bumi. Wilayah ini terdiri dari lebih dari 1.500 pulau kecil, gundukan pasir, dan terumbu karang yang mengelilingi empat pulau utama. Bentang alamnya yang unik terbagi menjadi beberapa zona keindahan yang dapat dinikmati oleh para wisatawan.

Zona 1 : Keanekaragaman Hayati Laut
Jantung dari Raja Ampat yang menjadi daya tarik utama bagi para penyelam dunia. Wilayah ini menyimpan 75% dari seluruh spesies karang yang ada di dunia. Terdapat lebih dari 1.300 spesies ikan, 537 spesies terumbu karang, dan 699 jenis moluska. Di sini, pengunjung bisa melihat langsung kehidupan bawah laut yang harmonis, mulai dari kuda laut kerdil hingga ikan pari Manta yang megah.

Zona 2 : Gugusan Pulau Karst (Piaynemo & Wayag)
Bentang alam ikonik yang terdiri dari bukit-bukit kapur runcing di tengah laut biru yang jernih. Untuk menikmati pemandangan ini, pengunjung harus mendaki ratusan anak tangga menuju puncak bukit. Dari atas, terlihat pemandangan labirin pulau-pulau kecil dan gradasi warna air laut dari hijau toska hingga biru tua yang menggambarkan ketenangan dan keajaiban alam.

Zona 3 : Desa Wisata (Arborek & Sawinggrai)
Sisi budaya dan interaksi sosial Raja Ampat, di mana kearifan lokal tetap terjaga. Di Desa Arborek, pengunjung dapat melihat kebersihan desa dan keramahan penduduk yang mahir membuat kerajinan tangan. Sementara di Sawinggrai, pengunjung memiliki kesempatan langka untuk melihat Burung Cenderawasih, "Burung Surga" asli Papua, melakukan tarian ritual di habitat aslinya.

Kekayaan Flora dan Fauna
Secara keseluruhan, Raja Ampat adalah rumah bagi berbagai satwa endemik. Selain kekayaan lautnya, hutan-hutan di pulau besarnya menyimpan jenis burung eksotis seperti Kakatua Raja dan berbagai jenis anggrek hutan yang langka.

Keindahan Tak Terlupakan
Selama berkunjung, wisatawan dapat menikmati berbagai aktivitas mulai dari *snorkeling*, menyelam, hingga *bird watching*. Setiap momen di Raja Ampat memberikan kesan mendalam tentang pentingnya menjaga kelestarian alam demi masa depan bumi.

Nikmati pengalaman berkunjung di Raja Ampat secara langsung digenggamanmu!''',
    },
    {
      'title': 'Candi Prambanan',
      'category': 'CULTURAL',
      'location': 'JAVA',
      'fact': 'Largest Hindu temple complex in Indonesia.',
      'imageUrl': 'assets/Prambanan.jpg',
      'description': '''Sejarah Candi Prambanan
Candi Prambanan adalah kompleks candi Hindu terbesar di Indonesia dan salah satu candi terindah di Asia Tenggara. Dikenal sebagai simbol kejayaan arsitektur kuno dan kemegahan budaya Hindu, Candi Prambanan memiliki sejarah yang kaya dan mendalam yang tercermin dalam setiap menara dan reliefnya yang menjulang tinggi.

Asal Usul Pembangunan
Dinasti Sanjaya membangun peninggalan Hindu terbesar ini pada sekitar tahun 850 Masehi, tepatnya pada masa pemerintahan Rakai Pikatan. Dinasti Sanjaya merupakan dinasti yang berkuasa di Kerajaan Mataram Kuno pada masa itu. Peninggalan ini dibangun sebagai persembahan untuk Trimurti, tiga dewa utama Hindu yaitu Brahma, Wisnu, dan Siwa. Tempat ini dibangun untuk menandai kembalinya kekuasaan keluarga Sanjaya di Jawa Tengah. Peninggalan ini ditemukan kembali dalam kondisi runtuh oleh orang Belanda bernama C.A. Lons pada tahun 1733. Area candi mulai dipugar secara serius pada tahun 1918 dan selesai pada tahun 1953.

Prambanan dibangun berdasarkan pedoman arsitektur Hindu, Vastu Shastra. Struktur bangunan ini mengikuti model alam semesta menurut kosmologi Hindu. Jika dilihat dari struktur tata letaknya, kompleks ini terbagi menjadi tiga zona yang menggambarkan tingkatan spiritual manusia dari alam bawah hingga alam para dewa.

Zona 1 : Bhurloka
Alam bawah tempat manusia yang masih terikat oleh hawa nafsu dan dosa. Bagian ini merupakan pelataran luar candi yang dahulu dikelilingi oleh tembok pagar. Di zona ini, terdapat beratus-ratus candi perwara (candi kecil) yang sebagian besar saat ini hanya menyisakan tumpukan batu sebagai pengingat akan kefanaan dunia materi.

Zona 2 : Bhuwarloka
Alam tengah atau alam antara, tempat bagi orang-orang suci, rishi, dan dewa-dewa tingkat rendah. Zona ini merupakan pelataran tengah yang terdiri dari empat undak-undakan. Di sini terdapat ratusan candi kecil yang disusun secara konsentris, melambangkan perjalanan jiwa menuju pencerahan spiritual yang lebih tinggi sebelum mencapai kesempurnaan.

Zona 3 : Swarloka
Alam tertinggi, rumah para dewa. Ini adalah pelataran pusat yang paling suci dan terletak di bagian paling atas. Di sini berdiri delapan candi utama dan delapan candi kecil. Tiga candi utama yang paling megah adalah Candi Siwa (tengah), Candi Wisnu (utara), dan Candi Brahma (selatan). Candi Siwa merupakan yang terbesar dengan ketinggian mencapai 47 meter.

Relief
Secara keseluruhan, dinding candi dihiasi dengan relief naratif yang menceritakan epos Ramayana dan Krishnayana. Relief ini dipahat pada dinding pagar langkan di sekeliling candi utama, menggambarkan perjalanan cinta, kesetiaan, dan perjuangan melawan kejahatan.

Koridor Candi
Selama penelitian arkeologi, ditemukan bahwa posisi Candi Prambanan tidak berdiri sendiri. Terdapat beberapa candi Hindu dan Buddha di sekitarnya yang menunjukkan toleransi beragama pada masa itu, seperti Candi Sewu, Candi Lumbung, dan Candi Bubrah. Candi Sewu, yang bercorak Buddha, terletak hanya sekitar 800 meter di sebelah utara Candi Prambanan.

Kompleks candi ini menjadi pusat perhatian dalam pementasan Sendratari Ramayana yang digelar secara rutin pada malam hari. Pertunjukan kolosal ini menggabungkan seni tari, drama, dan musik tradisional tanpa dialog, yang menceritakan kisah legendaris Rama dan Shinta dengan latar belakang kemegahan Candi Prambanan.

Nikmati pengalaman berkunjung di Candi Prambanan secara langsung digenggamanmu!''',
    },
    {
      'title': 'Gunung Bromo',
      'category': 'NATURE',
      'location': 'JAVA',
      'fact': 'An active volcano and part of the Tengger mountains.',
      'imageUrl': 'assets/Bromo.jpg',
      'description': '''Keajaiban Alam Gunung Bromo
Gunung Bromo adalah salah satu gunung berapi aktif yang paling ikonik dan menakjubkan di dunia. Dikenal sebagai simbol kemegahan alam Jawa Timur, Gunung Bromo memiliki lanskap vulkanik yang dramatis dan nilai budaya yang mendalam, yang tercermin dalam setiap kepulan asap kawahnya dan hamparan lautan pasirnya.

Asal Usul dan Kepercayaan
Masyarakat suku Tengger meyakini Gunung Bromo sebagai tempat suci yang berkaitan erat dengan legenda Roro Anteng dan Joko Seger. Nama "Bromo" sendiri diambil dari nama dewa utama dalam agama Hindu, yaitu Dewa Brahma. Gunung ini menjadi pusat spiritual bagi penduduk setempat yang merupakan keturunan langsung dari kerajaan Majapahit. Menurut legenda, pengorbanan anak bungsu pasangan tersebut ke kawah Bromo dilakukan demi keselamatan seluruh rakyat, yang kemudian menjadi awal mula tradisi syukur masyarakat setempat kepada sang pencipta.

Gunung Bromo berdiri gagah di dalam kaldera Tengger yang luas, mencerminkan kekuatan alam yang dahsyat sekaligus mempesona. Struktur geologinya unik dengan kawah yang terus mengepulkan asap putih, dikelilingi oleh hamparan pasir luas. Jika dilihat dari ketinggian, kawasan ini terbagi menjadi beberapa zona keindahan yang menyajikan pengalaman spiritual dan visual yang berbeda.

Zona 1 : Lautan Pasir (Segara Wedi)
Bentang alam berupa hamparan pasir luas seluas 10 kilometer persegi yang mengelilingi kaki Gunung Bromo. Zona ini menggambarkan tantangan fisik dan keteguhan hati manusia saat melintasi sunyinya padang pasir menuju puncak. Di sini, debu dan angin menciptakan suasana yang magis, mengingatkan kita pada kecilnya manusia di hadapan kekuatan alam semesta yang luas.

Zona 2 : Kawah Bromo
Pusat aktivitas vulkanik yang melambangkan kekuatan kehidupan dan kehancuran. Untuk mencapainya, pengunjung harus menaiki sekitar 250 anak tangga yang melambangkan usaha manusia menuju titik tertinggi. Di pinggir kawah, wisatawan dapat mencium aroma belerang dan mendengar gemuruh dari perut bumi, sebuah pengalaman yang memacu adrenalin sekaligus kekaguman akan keajaiban ciptaan Tuhan.

Zona 3 : Penanjakan (Puncak Matahari Terbit)
Titik tertinggi untuk menyaksikan keindahan matahari terbit yang disebut-sebut sebagai salah satu yang terbaik di dunia. Dari zona ini, kabut yang menyelimuti kaldera terlihat seperti samudera awan, menciptakan suasana sunyi dan murni seolah berada di negeri di atas awan. Momen ini sering dianggap sebagai waktu untuk refleksi diri dan mencari ketenangan batin.

Tradisi Yadnya Kasada
Secara keseluruhan, setiap tahun masyarakat Tengger melakukan ritual Yadnya Kasada, yaitu melarung hasil bumi dan ternak ke dalam kawah sebagai bentuk syukur dan permohonan keselamatan.

Kawasan Sekitar
Selama penjelajahan di kawasan Taman Nasional Bromo Tengger Semeru, ditemukan beberapa titik pelengkap keindahan, yaitu Bukit Teletubbies dan Pasir Berbisik yang lokasinya saling berdekatan. Bukit Teletubbies menawarkan hamparan sabana hijau yang kontras dengan warna abu-abu pasir, sementara Pasir Berbisik memberikan fenomena suara unik saat angin berhembus kencang.

Rangkaian lokasi ini membentuk rute wisata yang sempurna bagi mereka yang mencari petualangan sekaligus kedamaian. Setiap sudut Bromo bercerita tentang harmoni antara manusia, budaya, and alam liar yang tak tertandingi.

Nikmati pengalaman berkunjung di Gunung Bromo secara langsung digenggamanmu!''',
    },
    {
      'title': 'Kawa Ijen',
      'category': 'NATURE',
      'location': 'JAVA',
      'fact': 'Famous for its blue fire and sulfur mining.',
      'imageUrl': 'assets/Kawa_Ijen.jpg',
      'description': '''Pesona Kawah Ijen
Kawah Ijen adalah salah satu danau asam terbesar di dunia yang terletak di puncak Gunung Ijen, Jawa Timur. Dikenal sebagai keajaiban geologi yang langka, Kawah Ijen menawarkan pemandangan alam yang dramatis dan fenomena api biru yang mendunia, mencerminkan kekuatan tektonik dan kekayaan mineral yang terkandung di perut bumi.

Asal Usul dan Fenomena
Kompleks Gunung Ijen terbentuk melalui aktivitas vulkanik ribuan tahun yang lalu di dalam Kaldera Ijen yang sangat luas. Kawasan ini mulai dikenal secara global karena keberadaan tambang belerang tradisional dan fenomena Blue Fire (Api Biru) yang hanya ada dua di dunia. Tempat ini menjadi simbol ketangguhan manusia, di mana para penambang belerang bekerja melawan gas beracun demi menghidupi keluarga. Kawah ini pertama kali menarik perhatian peneliti internasional pada awal abad ke-20 karena tingkat keasamannya yang sangat tinggi, mendekati angka nol, yang mampu melarutkan logam dalam sekejap.

Kawah Ijen berada pada ketinggian 2.386 meter di atas permukaan laut. Struktur kawasannya terdiri dari dinding kaldera yang terjal dan danau kawah berwarna hijau toska yang kontras dengan bebatuan belerang yang kuning cerah. Jika dijelajahi, kawasan ini terbagi menjadi tiga zona pengalaman yang menyajikan keajaiban berbeda bagi para pendaki.

Zona 1 : Jalur Pendakian (Rim)
Area awal berupa jalur setapak menanjak sejauh 3 kilometer yang dikelilingi oleh hutan pegunungan dan pohon Manisrejo. Zona ini menggambarkan perjuangan fisik manusia dalam menaklukkan medan yang curam. Di sepanjang jalur ini, pengunjung akan berpapasan dengan para penambang belerang yang memikul beban hingga 80 kilogram, sebuah pemandangan yang mengajarkan tentang arti kerja keras dan daya tahan manusia.

Zona 2 : Bibir Kawah (Craterside)
Titik tertinggi di mana wisatawan dapat melihat pemandangan panorama danau asam seluas 546 hektar. Dari sini, terlihat kepulan asap putih tebal yang berasal dari sublimasi gas belerang. Zona ini menawarkan transisi pandangan dari kegelapan malam menuju fajar, di mana gradasi warna langit bertemu dengan hijaunya air danau, menciptakan suasana yang megah namun mencekam.

Zona 3 : Dasar Kawah (Blue Fire)
Area paling ekstrem yang berada di dekat sumber gas belerang. Di sini, terjadi fenomena kimia di mana gas belerang keluar dari rekahan bumi dengan suhu tinggi dan terbakar saat bersentuhan dengan udara, menghasilkan lidah api berwarna biru elektrik. Bagian ini menggambarkan kemurnian energi bumi yang sangat kuat dan hanya dapat disaksikan pada saat hari masih gelap sebelum matahari terbit.

Aktivitas Tambang
Secara keseluruhan, terdapat puluhan penambang yang setiap hari naik-turun kawah untuk mengambil bongkahan belerang beku menggunakan alat tradisional di tengah kepulan asap gas.

Kawasan Sekitar
Selama perjalanan menuju atau pulang dari Ijen, terdapat beberapa objek wisata pendukung yang lokasinya searah, yaitu Air Terjun Jagir dan Kawah Wurung. Air Terjun Jagir berada di kaki gunung dengan airnya yang jernih, sementara Kawah Wurung menyajikan hamparan perbukitan hijau yang sering disebut sebagai "Highland" van Java karena keindahannya yang menyerupai pemandangan di Skotlandia.

Rangkaian lokasi ini membentuk perjalanan yang memadukan petualangan fisik, edukasi geologi, dan empati sosial. Setiap langkah di Ijen memberikan pelajaran tentang keajaiban alam dan keberanian manusia yang hidup berdampingan dengannya.

Nikmati pengalaman berkunjung di Kawah Ijen secara langsung digenggamanmu!''',
    },
    {
      'title': 'Pantai Kuta',
      'category': 'BEACH',
      'location': 'BALI',
      'fact': 'Popular surfing spot with stunning sunsets.',
      'imageUrl': 'assets/Kuta.jpg',
      'description': '''Pesona Pantai Kuta
Pantai Kuta adalah salah satu destinasi wisata paling ikonik di Bali dan menjadi pusat pariwisata internasional di Indonesia. Dikenal dengan garis pantai berpasir putih yang luas dan ombaknya yang menantang, Pantai Kuta menawarkan perpaduan antara keindahan alam yang eksotis dan dinamika kehidupan modern yang tak pernah tidur.

Asal Usul dan Perkembangan
Awalnya, Kuta merupakan pelabuhan dagang tradisional di Bali yang menjadi tempat bertemunya pedagang lokal dengan pelaut asing. Kawasan ini mulai dikenal dunia internasional pada awal tahun 1930-an ketika seorang ekspatriat Amerika, Robert Koke, membangun hotel pertama di sini. Namun, popularitasnya meledak pada tahun 1970-an saat para peselancar dunia menemukan ombak Kuta yang sempurna. Kini, pantai ini telah bertransformasi dari desa nelayan yang sunyi menjadi pusat hiburan, perbelanjaan, dan gaya hidup di Pulau Dewata.

Bentang alam Pantai Kuta membentang sepanjang beberapa kilometer dengan pemandangan cakrawala laut yang tak terbatas. Kawasan ini dikelola dengan baik dan terbagi menjadi beberapa zona pengalaman yang menarik bagi setiap jenis pengunjung.

Zona 1 : Hamparan Pasir Putih (Area Santai)
Wilayah pesisir yang landai dengan butiran pasir putih yang halus. Di zona ini, pengunjung dapat menikmati aktivitas santai seperti berjemur, bermain voli pantai, atau sekadar berjalan kaki menyusuri pantai. Tempat ini adalah ruang terbuka bagi siapa saja untuk menikmati suasana tropis yang hangat sambil merasakan hembusan angin laut yang menyegarkan.

Zona 2 : Area Selancar (The Waves)
Jantung aktivitas olahraga air di Kuta yang sangat terkenal di kalangan peselancar pemula hingga profesional. Ombak di sini pecah di atas dasar pasir (sand break), sehingga relatif aman bagi mereka yang baru belajar berselancar. Terdapat banyak sekolah selancar di sepanjang pantai yang siap membantu wisatawan menaklukkan ombak pertama mereka di bawah bimbingan pelatih berpengalaman.

Zona 3 : Pemandangan Matahari Terbenam (Sunset View)
Momen paling sakral dan dinanti di Pantai Kuta adalah saat matahari terbenam. Pada zona ini, langit berubah menjadi kanvas berwarna jingga, merah muda, dan ungu yang memantul di atas permukaan air laut. Pemandangan matahari terbenam di Kuta sering disebut sebagai salah satu yang terbaik di dunia, menciptakan suasana romantis dan damai yang tak terlupakan.

Aktivitas Utama
Secara keseluruhan, aktivitas di Pantai Kuta tidak hanya terbatas pada siang hari. Saat malam tiba, kawasan ini tetap hidup dengan berbagai festival budaya, musik jalanan, dan pelepasan tukik (bayi penyu) sebagai bagian dari upaya pelestarian lingkungan.

Kawasan Sekitar
Selama berada di area Kuta, pengunjung dapat mengeksplorasi lokasi pendukung yang sangat dekat, yaitu Monumen Ground Zero dan Jalan Legian. Monumen Ground Zero dibangun sebagai penghormatan bagi para korban peristiwa bom Bali, sementara Jalan Legian adalah pusat perbelanjaan dan kehidupan malam yang letaknya hanya beberapa ratus meter dari garis pantai.

Rangkaian lokasi ini membentuk ekosistem wisata yang lengkap bagi para pencari petualangan maupun kenyamanan. Setiap sudut Kuta bercerita tentang keajaiban alam dan semangat keramahan masyarakat Bali yang mendunia.

Nikmati pengalaman berkunjung di Pantai Kuta secara langsung digenggamanmu!''',
    },
    {
      'title': 'Labuan Bajo',
      'category': 'NATURE',
      'location': 'FLORES',
      'fact': 'Gateway to Komodo National Park.',
      'imageUrl': 'assets/Labuan_Bajo.webp',
      'description': '''Pesona Wisata Labuan Bajo
Labuan Bajo adalah sebuah surga tersembunyi yang terletak di ujung barat Pulau Flores, Nusa Tenggara Timur. Dikenal sebagai gerbang utama menuju Taman Nasional Komodo, Labuan Bajo menawarkan perpaduan pemandangan bukit yang eksotis, laut biru yang jernih, dan pulau-pulau vulkanik yang menakjubkan.

Asal Usul dan Perkembangan
Awalnya, Labuan Bajo hanyalah sebuah desa nelayan kecil yang tenang. Namun, seiring dengan ditetapkannya Taman Nasional Komodo sebagai Situs Warisan Dunia UNESCO pada tahun 1991 dan terpilih sebagai salah satu dari "New 7 Wonders of Nature", wilayah ini berkembang pesat menjadi destinasi wisata premium. Nama "Labuan Bajo" berasal dari kata "Labuan" yang berarti pelabuhan, dan "Bajo" yang merujuk pada Suku Bajo, para pengembara laut yang tangguh.

Labuan Bajo berfungsi sebagai pusat navigasi bagi para penjelajah laut. Struktur wisatanya unik karena menggabungkan petualangan darat dan laut yang terbagi menjadi beberapa zona keindahan yang dapat dinikmati oleh para wisatawan.

Zona 1 : Pelabuhan dan Waterfront
Jantung aktivitas kota yang menjadi titik tolak petualangan. Di sini, pengunjung dapat melihat deretan kapal pinisi yang megah bersandar di dermaga. Zona ini mencerminkan dinamika kehidupan pesisir yang modern namun tetap menjaga kearifan lokal melalui pasar ikan tradisional dan kuliner laut yang segar.

Zona 2 : Pulau Padar (Puncak Perbukitan)
Ikon visual Labuan Bajo yang menyajikan pemandangan lanskap prasejarah. Setelah mendaki ratusan anak tangga, pengunjung akan disuguhi panorama tiga teluk dengan warna pasir yang berbeda: putih, merah muda, dan hitam. Zona ini melambangkan kemegahan geologi kepulauan Nusa Tenggara yang tak tertandingi.

Zona 3 : Taman Nasional Komodo
Pusat ekosistem yang paling suci dan dilindungi, rumah bagi Varanus komodoensis. Di sini, pengunjung dapat melihat langsung naga purba terakhir di dunia di habitat aslinya. Zona ini menggambarkan harmoni antara pelestarian spesies langka dengan keajaiban alam liar yang masih murni.

Keanekaragaman Hayati Laut
Secara keseluruhan, perairan di sekitar Labuan Bajo memiliki kekayaan bawah laut yang luar biasa, mulai dari Manta Point tempat berkumpulnya ikan pari raksasa hingga terumbu karang yang sangat terjaga.

Objek Wisata Sekitar
Selama perjalanan, wisatawan juga sering mengunjungi objek wisata pendukung seperti Pink Beach yang memiliki pasir merah muda yang langka, serta Gua Batu Cermin yang menampilkan fosil biota laut di dinding gua, membuktikan bahwa daratan ini dahulu berada di bawah laut.

Kawasan ini menjadi rute utama bagi kapal-kapal "Liveaboard" yang membawa wisatawan mengarungi samudra selama beberapa hari, memberikan pengalaman mendalam tentang kehidupan di atas laut yang tenang.

Nikmati pengalaman berkunjung di Labuan Bajo secara langsung digenggamanmu!''',
    },
    {
      'title': 'Malioboro Street',
      'category': 'CITY',
      'location': 'YOGYAKARTA',
      'fact': 'A vibrant shopping street with traditional markets.',
      'imageUrl': 'assets/Malioboro.jpg',
      'description': '''Sejarah Jalan Malioboro
Jalan Malioboro adalah jantung kota Yogyakarta dan salah satu jalan paling ikonik di Indonesia. Dikenal sebagai simbol denyut nadi ekonomi dan budaya Jawa, Malioboro menyimpan sejarah panjang yang melintasi berbagai zaman, mulai dari era kerajaan hingga masa kolonial dan kemerdekaan.

Asal Usul Pembangunan
Nama "Malioboro" diyakini berasal dari bahasa Sanskerta "Malyabhara" yang berarti "berhiaskan karangan bunga". Namun, ada juga yang mengaitkannya dengan Duke of Marlborough, seorang jenderal Inggris yang berkuasa di Jawa pada awal abad ke-19. Jalan ini mulai berkembang secara signifikan pada masa pemerintahan Sultan Hamengkubuwono I sekitar tahun 1756 seiring dengan pembangunan Keraton Yogyakarta. Kawasan ini dulunya merupakan jalur prosesi upacara kerajaan dan kemudian menjadi pusat perdagangan pada masa kolonial Belanda seiring dengan dibersihkannya area perkotaan.

Malioboro dirancang dalam satu garis lurus (Garis Imajiner) yang menghubungkan Gunung Merapi, Tugu Pal Putih, Keraton Yogyakarta, dan Laut Selatan. Jika dilihat dari fungsi dan suasananya, jalan ini terbagi menjadi beberapa zona yang menggambarkan transisi antara aktivitas komersial, sejarah, dan seni budaya.

Zona 1 : Area Stasiun dan Pasar
Meliputi ujung utara jalan dekat Stasiun Tugu hingga Pasar Beringharjo. Zona ini adalah pusat aktivitas ekonomi tertua, tempat bertemunya pedagang dari berbagai penjuru yang menawarkan tekstil, rempah-rempah, dan barang antik sebagai penggerak ekonomi rakyat.

Zona 2 : Teras Malioboro
Area yang kini ditata rapi untuk para pedagang kaki lima dan seniman lokal. Di sini manusia berinteraksi melalui kerajinan tangan khas Yogyakarta dan sajian kuliner legendaris. Zona ini mencerminkan keramahan dan kreativitas warga lokal dalam melestarikan budaya di tengah modernisasi.

Zona 3 : Titik Nol Kilometer
Bagian ujung selatan yang dikelilingi oleh bangunan bersejarah bergaya kolonial seperti Kantor Pos Besar, Bank Indonesia, dan Benteng Vredeburg. Area ini melambangkan pusat pemerintahan dan pertahanan masa lalu yang kini menjadi ruang publik terbuka untuk apresiasi sejarah.

Seni dan Budaya
Sepanjang trotoar dihiasi dengan berbagai instalasi seni, bangku-bangku ikonik, dan lampu jalan bergaya klasik yang memberikan jiwa pada koridor jalan ini sebagai ruang ekspresi para seniman.

Koridor Jalan
Malioboro tidak berdiri sendiri; ia merupakan bagian dari sumbu filosofis Yogyakarta. Hanya berjarak beberapa ratus meter ke arah selatan, pengunjung dapat mencapai kompleks Keraton Yogyakarta dan Alun-alun Utara yang segaris dengan jalan ini.

Kawasan ini menjadi pusat berbagai acara besar seperti Pawai Budaya dan peringatan HUT Kota Yogyakarta. Festival tersebut menjadi magnet bagi wisatawan untuk menyaksikan perpaduan harmonis antara tradisi keraton dan kehidupan masyarakat modern.

Nikmati pengalaman berkunjung di Jalan Malioboro secara langsung digenggamanmu!''',
    },
    {
      'title': 'Nusa Penida',
      'category': 'ISLAND',
      'location': 'BALI',
      'fact': 'Known for its dramatic cliffs and pristine beaches.',
      'imageUrl': 'assets/Nusa_Penida.jpg',
      'description': '''Pesona Wisata Nusa Penida
Nusa Penida adalah sebuah pulau eksotis yang terletak di tenggara Bali, dikenal sebagai permata tersembunyi dengan tebing-tebing dramatis, pantai berpasir putih, dan kehidupan bawah laut yang memukau. Dikenal sebagai simbol keindahan alam yang masih alami, Nusa Penida memiliki daya tarik yang kuat bagi para petualang dan pencinta alam.

Asal Usul dan Perkembangan
Nusa Penida, bersama dengan Nusa Lembongan dan Nusa Ceningan, merupakan bagian dari gugusan pulau kecil di lepas pantai tenggara Bali. Secara historis, pulau ini dulunya dianggap sebagai tempat pengasingan atau pulau mistis yang dihuni oleh roh-roh jahat. Namun, sejak awal tahun 2000-an, keindahan alamnya mulai terkuak dan menarik perhatian wisatawan internasional, terutama setelah media sosial mempopulerkan ikon-ikon seperti Kelingking Beach. Nama "Nusa Penida" sendiri berarti "Pulau Pendeta" atau "Pulau Para Dewa" dalam bahasa Bali.

Nusa Penida terbentuk dari formasi geologi kapur yang menciptakan tebing-tebing curam dan gua-gua alami. Struktur alamnya yang unik terbagi menjadi beberapa zona keindahan yang menawarkan pengalaman berbeda bagi para pengunjung.

Zona 1 : Pantai Barat (Ikonik & Fotogenik)
Meliputi area seperti Kelingking Beach, Broken Beach (Pasih Uug), dan Angel's Billabong. Zona ini adalah rumah bagi pemandangan tebing kapur yang ikonik, formasi batuan alami yang menyerupai T-Rex, dan kolam alami yang jernih. Menggambarkan keajaiban geologi yang terbentuk oleh erosi laut selama ribuan tahun.

Zona 2 : Pantai Timur (Tenang & Tersembunyi)
Termasuk Diamond Beach dan Atuh Beach. Zona ini menawarkan pantai-pantai berpasir putih yang lebih tenang dengan pemandangan tebing yang tak kalah menakjubkan. Di sini, pengunjung dapat menikmati suasana damai dan keindahan alam yang masih perawan, jauh dari keramaian.

Zona 3 : Bawah Laut (Surga Penyelam)
Meliputi spot-spot seperti Manta Point dan Crystal Bay. Zona ini adalah surga bagi para penyelam dan *snorkeler* dengan keanekaragaman hayati laut yang luar biasa, termasuk ikan pari manta, penyu, dan terumbu karang yang sehat. Menggambarkan kekayaan ekosistem laut yang dilindungi dan dijaga kelestariannya.

Kehidupan Lokal
Secara keseluruhan, masyarakat Nusa Penida masih sangat menjaga tradisi dan budaya Bali. Pengunjung dapat melihat aktivitas sehari-hari seperti bertani rumput laut atau upacara adat yang masih sering dilakukan.

Koridor Wisata
Selama perjalanan di Nusa Penida, pengunjung dapat menjelajahi berbagai gua suci seperti Goa Giri Putri, sebuah gua besar yang di dalamnya terdapat pura Hindu. Pulau ini juga memiliki beberapa air terjun tersembunyi yang menambah daftar petualangan.

Ketiga zona ini membentuk rute eksplorasi yang sempurna bagi mereka yang mencari petualangan, keindahan alam, dan ketenangan. Setiap sudut Nusa Penida bercerita tentang keajaiban alam yang tak tersentuh dan budaya yang kuat.

Nikmati pengalaman berkunjung di Nusa Penida secara langsung digenggamanmu!''',
    },
    {
      'title': 'Pulau Komodo',
      'category': 'NATURE',
      'location': 'FLORES',
      'fact': 'Home to the Komodo dragon, the world\'s largest lizard.',
      'imageUrl': 'assets/Pulau_Komodo.jpg',
      'description': '''Pesona Pulau Komodo
Pulau Komodo adalah salah satu keajaiban alam paling spektakuler di dunia dan rumah bagi naga purba terbesar yang masih hidup. Dikenal sebagai simbol ketangguhan alam dan evolusi dari masa lalu, Pulau Komodo memiliki kekayaan hayati yang kaya dan mendalam yang tercermin dalam setiap bukit gersang dan ekosistem lautnya.

Asal Usul dan Status
Pemerintah Indonesia menetapkan kawasan ini sebagai Taman Nasional Komodo pada tahun 1980. Kawasan ini kemudian diakui sebagai Situs Warisan Dunia oleh UNESCO pada tahun 1991. Peninggalan alam purba ini dijaga sebagai tempat pelestarian komodo (Varanus komodoensis) dan keanekaragaman hayati lainnya. Tempat ini merupakan laboratorium alam yang mengajarkan manusia tentang pentingnya konservasi dan menjaga keseimbangan ekosistem bumi. Kepulauan ini mulai dikenal luas secara internasional karena keunikan satwanya yang tidak dapat ditemukan di tempat lain di dunia.

Kawasan Komodo terbentuk dari aktivitas vulkanik yang mencerminkan kekuatan tektonik di wilayah Nusa Tenggara. Struktur lanskap ini terdiri dari pulau-pulau dengan bukit-bukit kapur dan padang sabana yang luas. Jika dilihat dari sudut pandang ekologi, kawasan ini terbagi menjadi tiga zona yang menggambarkan tingkatan habitat dari pesisir hingga kedalaman laut.

Zona 1 : Loh Liang
Area pintu gerbang dan pintu masuk utama di mana manusia mulai berinteraksi dengan lingkungan konservasi. Zona ini merupakan pelataran awal yang berfungsi sebagai pusat informasi dan titik awal pendakian. Di sini, terdapat fasilitas penunjang yang dibangun dengan memperhatikan kelestarian alam agar tidak mengganggu habitat asli satwa.

Zona 2 : Sabana dan Hutan Kering
Alam peralihan tempat kehidupan liar berlangsung secara murni. Zona ini terdiri dari perbukitan gersang dan hutan yang menjadi rumah bagi komodo, rusa, dan kerbau liar. Secara keseluruhan, lanskap ini menggambarkan siklus hidup yang keras namun harmonis, di mana predator dan mangsa hidup berdampingan dalam keseimbangan alam yang sempurna.

Zona 3 : Perairan Taman Nasional
Alam bawah laut yang menjadi rumah bagi ribuan spesies laut. Perairan ini mengelilingi gugusan pulau dan merupakan salah satu lokasi menyelam terbaik di dunia. Di bagian ini, keindahan terumbu karang dan biota laut seperti pari manta menggambarkan kemurnian alam bawah laut yang masih terjaga keasliannya dari campur tangan manusia.

Lanskap
Secara keseluruhan terdapat bukit-bukit ikonik dengan lekukan tanah yang menyerupai kulit naga purba, menciptakan pemandangan yang megah di sepanjang pulau.

Koridor Kepulauan
Selama eksplorasi di kawasan ini, ditemukan beberapa pulau pendukung yang memiliki nilai konservasi serupa, yaitu Pulau Rinca dan Pulau Padar yang berada dalam satu garis kepulauan. Pulau Rinca merupakan habitat komodo lainnya, sementara Pulau Padar menawarkan panorama tiga pantai yang ikonik.

Rangkaian lokasi ini membentuk rute wisata edukasi melalui Festival Komodo yang digelar secara berkala untuk mempromosikan pariwisata berkelanjutan. Festival tersebut sebagai pengingat akan pentingnya menjaga warisan alam dunia ini demi generasi mendatang.

Nikmati pengalaman berkunjung di Pulau Komodo secara langsung digenggamanmu!''',
    },
    {
      'title': 'Danau Toba',
      'category': 'NATURE',
      'location': 'SUMATRA',
      'fact': 'The largest volcanic lake in the world.',
      'imageUrl': 'assets/Toba.jpg',
      'description': '''Pesona Alam Danau Toba
Danau Toba adalah danau vulkanik terbesar di dunia yang terletak di Sumatera Utara. Dikenal sebagai simbol kemegahan alam dan warisan geologi dunia, Danau Toba memiliki sejarah yang kaya dan mendalam yang tercermin dalam setiap hamparan air biru dan perbukitan hijaunya.

Asal Usul Pembentukan
Letusan supervolcano Toba sekitar 74.000 tahun lalu membentuk kaldera raksasa ini. Letusan tersebut merupakan salah satu letusan gunung berapi terbesar dalam sejarah bumi yang mengubah iklim global seiring dengan penyebaran abu vulkaniknya. Peninggalan alam ini kini menjadi UNESCO Global Geopark. Tempat ini merupakan saksi bisu kekuatan tektonik yang dahsyat dan kini menjadi sumber kehidupan bagi masyarakat Batak di sekelilingnya. Area ini telah menjadi pusat perhatian peneliti dunia sejak awal abad ke-20 karena keunikan geologinya.

Danau Toba terbentuk dengan gaya alami yang mencerminkan kekuatan bumi yang luar biasa. Struktur kawasan ini terdiri dari kaldera luas dengan Pulau Samosir sebagai titik pusatnya yang berbentuk pulau di dalam pulau. Jika dilihat dari tepian hingga ke pusatnya, kawasan ini terbagi menjadi beberapa zona keindahan yang menggambarkan harmoni antara alam dan tradisi.

Zona 1 : Kawasan Pesisir (Parapat)
Alam dunia tempat interaksi manusia dan gerbang utama menuju keajaiban danau. Parapat merupakan pusat pariwisata tertua di tepi danau yang menawarkan fasilitas modern di tengah lanskap purba. Di sini, pengunjung dapat menikmati panorama tepi danau sambil merasakan denyut nadi ekonomi masyarakat lokal.

Zona 2 : Pulau Samosir (Pusat Budaya)
Alam peralihan yang menyimpan kekayaan tradisi dan sejarah leluhur masyarakat Batak. Di zona ini terdapat desa-desa adat seperti Tomok dan Ambarita yang memamerkan rumah adat Bolon dan kursi batu kuno. Samosir adalah tempat di mana jiwa dan semangat tradisi tetap terjaga melalui tarian Sigale-gale dan seni tenun Ulos yang legendaris.

Zona 3 : Perairan dan Tebing (Kaldera)
Alam tertinggi yang menggambarkan ketenangan dan kemurnian. Perairan luas dengan kedalaman mencapai 500 meter dikelilingi oleh tebing-tebing kapur yang menjulang tinggi. Pada bagian ini, gradasi warna air laut dan pantulan awan di permukaan danau menggambarkan kemurnian alam yang masih terjaga keasliannya.

Hayati
Secara keseluruhan terdapat spesies endemik seperti Ikan Batak (Neolissochilus thienemanni) yang dianggap sakral dan dijaga populasinya oleh penduduk setempat di sepanjang perairan danau.

Koridor Wisata
Selama penjelajahan di sekitar Toba, ditemukan beberapa titik keindahan lainnya seperti Air Terjun Sipiso-piso yang menjulang tinggi dan Bukit Simarjarunjung yang segaris dengan panorama Danau Toba. Sipiso-piso berada di sisi utara danau, sementara Simarjarunjung menawarkan sudut pandang terbaik untuk melihat kemegahan kaldera secara utuh.

Kawasan ini membentuk rute untuk Festival Danau Toba yang digelar tiap tahun saat musim kunjungan wisata. Festival tersebut sebagai peringatan atas kekayaan budaya, tradisi lokal, serta rasa syukur atas pencerahan dan keindahan alam yang diberikan oleh Sang Pencipta melalui alam Toba.

Nikmati pengalaman berkunjung di Danau Toba secara langsung digenggamanmu!''',
    },
    {
      'title': 'Tana Toraja',
      'category': 'CULTURAL',
      'location': 'SULAWESI',
      'fact': 'Unique funeral ceremonies and traditional houses.',
      'imageUrl': 'assets/Tana_Toraja.jpg',
      'description': '''Sejarah Tana Toraja
Tana Toraja adalah salah satu destinasi budaya paling unik dan sakral di Indonesia. Dikenal sebagai simbol penghormatan terhadap leluhur dan kehidupan setelah mati, Tana Toraja memiliki sejarah yang kaya dan mendalam yang tercermin dalam setiap rumah adat Tongkonan dan tebing pemakamannya.

Asal Usul Budaya
Masyarakat Toraja telah menetap di pegunungan Sulawesi Selatan sejak ribuan tahun lalu. Budaya ini berkembang sebagai bentuk sinkretisme antara kepercayaan asli Aluk To Dolo dan perkembangan zaman. Toraja mulai dikenal dunia internasional pada awal tahun 1970-an setelah wisatawan dan peneliti antropologi mulai mengeksplorasi keunikan upacara pemakaman Rambu Solo. Kawasan ini ditetapkan sebagai kawasan pelestarian budaya yang sangat dijaga keasliannya. Tempat ini berisi ajaran agar manusia selalu menghormati orang tua dan menjaga keseimbangan antara dunia manusia dan dunia roh.

Tana Toraja dibangun dengan filosofi harmoni antara manusia, alam, dan Tuhan. Struktur pemukiman dan tradisinya mengikuti konsep kosmologi Toraja yang sangat terikat dengan tanah kelahiran. Jika dilihat dari sisi spiritualitasnya, tatanan kehidupan Toraja terbagi menjadi tiga zona yang menggambarkan perjalanan manusia dari lahir hingga menuju Puya (dunia arwah).

Zona 1 : Dunia Kehidupan (Tongkonan)
Alam dunia tempat manusia menjalankan aktivitas harian. Tongkonan bukan sekadar rumah, melainkan pusat identitas keluarga yang melambangkan status sosial dan hubungan kekerabatan. Atapnya yang berbentuk perahu menghadap ke utara, melambangkan asal-usul leluhur mereka yang datang dari arah laut.

Zona 2 : Masa Transisi (Upacara Pemakaman)
Alam peralihan bagi mereka yang telah meninggal namun dianggap masih "sakit". Melalui upacara Rambu Solo yang megah, keluarga melepas anggota mereka menuju keabadian. Di zona ini terdapat penyembelihan kerbau yang dipercaya sebagai kendaraan bagi arwah menuju surga, mencerminkan pengabdian terakhir anak kepada orang tua.

Zona 3 : Dunia Keabadian (Lemo & Londa)
Alam tertinggi tempat bersemayamnya para leluhur di tebing-tebing batu. Di sini terdapat Tau-tau (patung kayu) yang diletakkan di balkon lubang gua sebagai penjaga. Tempat ini menggambarkan kemurnian spiritual di mana kematian bukan akhir, melainkan awal dari kehidupan yang lebih tenang bersama Sang Pencipta.

Ukiran
Secara keseluruhan terdapat ratusan motif ukiran Passura pada dinding Tongkonan yang masing-masing memiliki arti mendalam tentang kebijaksanaan, persatuan, dan keadilan.

Kawasan Budaya
Selama penjelajahan di Toraja, ditemukan berbagai situs yang saling berkaitan, yaitu Desa Kete Kesu yang masih sangat asli dan Londa yang merupakan pemakaman gua alam. Kete Kesu berada sebagai pusat peradaban, sementara Londa memberikan gambaran tentang tradisi pemakaman yang telah berusia ratusan tahun.

Kawasan ini menjadi pusat pelaksanaan Festival Budaya Toraja yang digelar secara berkala untuk menampilkan kekayaan seni tari dan musik bambu. Festival tersebut sebagai peringatan atas warisan leluhur dan upaya menjaga tradisi agar tidak lekang oleh waktu.

Nikmati pengalaman berkunjung di Tana Toraja secara langsung digenggamanmu!''',
    },
    {
      'title': 'Wakatobi',
      'category': 'NATURE',
      'location': 'SULAWESI',
      'fact': 'Home to 750 coral species worldwide.',
      'imageUrl': 'assets/Wakatobi.jpg',
      'description': '''Pesona Taman Nasional Wakatobi
Wakatobi adalah surga bawah laut di Sulawesi Tenggara yang merupakan bagian dari Segitiga Terumbu Karang dunia. Nama Wakatobi sendiri merupakan akronim dari empat pulau utama: Wangi-Wangi, Kaledupa, Tomia, dan Binongko.

Asal Usul dan Status
Kawasan ini ditetapkan sebagai Taman Nasional pada tahun 1996 dan Cagar Biosfer Dunia oleh UNESCO pada tahun 2012. Wakatobi memiliki kekayaan hayati laut yang sangat tinggi. Kehidupan di sini sangat dipengaruhi oleh tradisi Suku Bajo yang dikenal sebagai "Sea Gypsies" atau pengembara laut yang telah menetap selama berabad-abad.

Wakatobi terbagi menjadi beberapa zona keindahan yang mencerminkan kekayaan maritim dan budaya lokal yang sangat terjaga keasliannya.

Zona 1 : Pulau Wangi-Wangi
Pintu gerbang utama dan pusat administratif. Zona ini merupakan titik awal bagi wisatawan untuk mengenal keramahan masyarakat lokal dan menikmati hasil laut segar.

Zona 2 : Terumbu Karang Tomia
Jantung keanekaragaman hayati bawah laut dengan dinding karang yang spektakuler. Di sini pengunjung dapat menyaksikan harmoni ekosistem laut yang sangat murni.

Zona 3 : Kampung Suku Bajo
Alam budaya yang unik di mana rumah-rumah penduduk dibangun di atas air menggunakan tiang kayu. Zona ini menggambarkan ketangguhan manusia dan kearifan lokal dalam menjaga laut.

Nikmati pengalaman berkunjung di Wakatobi secara langsung digenggamanmu!''',
    },
    {
      'title': 'Gunung Rinjani',
      'category': 'NATURE',
      'location': 'LOMBOK',
      'fact': 'The second highest volcano in Indonesia.',
      'imageUrl': 'assets/Rinjani.jpg',
      'description': '''Keajaiban Gunung Rinjani
Gunung Rinjani adalah gunung berapi tertinggi kedua di Indonesia yang terletak di Pulau Lombok. Dikenal karena keindahan kawah raksasanya, Rinjani menjadi ikon petualangan bagi para pendaki dari seluruh dunia.

Asal Usul dan Kepercayaan
Masyarakat Sasak dan Hindu meyakini Rinjani sebagai tempat suci yang dihuni oleh Dewi Anjani. Puncak Rinjani dianggap sebagai tempat tinggal para dewa, mencerminkan hubungan mendalam antara manusia dengan kekuatan alam yang agung.

Gunung Rinjani memiliki topografi yang menantang dengan hamparan padang rumput dan hutan hujan tropis yang terbagi menjadi tiga zona pengalaman yang berbeda.

Zona 1 : Jalur Sembalun
Titik awal pendakian yang menyajikan hamparan padang rumput (sabana) luas. Zona ini menggambarkan awal perjalanan fisik manusia dalam menaklukkan batas kemampuan diri.

Zona 2 : Danau Segara Anak
Kawah raksasa di tengah gunung dengan air biru jernih. Zona ini melambangkan ketenangan di tengah aktivitas vulkanik yang dahsyat, tempat pendaki beristirahat dan berefleksi.

Zona 3 : Puncak Rinjani (3.726 mdpl)
Titik tertinggi yang menawarkan pandangan ke arah Gunung Agung di Bali. Momen mencapai puncak saat matahari terbit adalah simbol kemenangan atas rintangan hidup.

Nikmati pengalaman berkunjung di Gunung Rinjani secara langsung digenggamanmu!''',
    },
    {
      'title': 'Dieng Plateau',
      'category': 'CULTURAL',
      'location': 'JAVA',
      'fact': 'Known as the "Abode of the Gods".',
      'imageUrl': 'assets/Dieng.jpg',
      'description': '''Negeri di Atas Awan Dieng
Dataran Tinggi Dieng adalah kawasan vulkanik aktif di Jawa Tengah yang terletak pada ketinggian lebih dari 2.000 meter. Dikenal sebagai "Negeri di Atas Awan", Dieng menawarkan kombinasi sejarah kuno dan fenomena alam magis.

Asal Usul Pembangunan
Nama Dieng berasal dari bahasa Sanskerta "Di" (tempat) dan "Hyang" (dewa). Di sini berdiri kompleks candi Hindu tertua di Jawa yang dibangun oleh Dinasti Sanjaya pada abad ke-8 Masehi sebagai bentuk pengabdian kepada Dewa Siwa di tempat yang dekat dengan langit.

Lanskap Dieng didominasi perbukitan hijau dan kawah belerang aktif yang terbagi menjadi tiga zona wisata filosofis.

Zona 1 : Kompleks Candi Arjuna
Pusat sejarah Dieng yang terdiri dari candi-candi megah. Zona ini mencerminkan kejayaan awal peradaban Hindu di Jawa dan merupakan museum arsitektur terbuka.

Zona 2 : Kawah Sikidang
Fenomena geologi yang menarik di mana kawah utama sering berpindah-pindah. Di sini pengunjung melihat energi alam yang terus berdenyut di bawah permukaan bumi.

Zona 3 : Telaga Warna
Danau vulkanik yang berubah warna karena kandungan belerang. Zona ini menggambarkan keajaiban optik dan ketenangan alam yang sangat mempesona.

Nikmati pengalaman berkunjung di Dieng secara langsung digenggamanmu!''',
    },
    {
      'title': 'Tanah Lot',
      'category': 'CULTURAL',
      'location': 'BALI',
      'fact': 'A famous offshore temple on a rock.',
      'imageUrl': 'assets/Tanah_Lot.jpg',
      'description': '''Kemegahan Pura Tanah Lot
Pura Tanah Lot adalah ikon wisata Bali yang berdiri megah di atas batu karang besar di pinggir laut. Tanah Lot merupakan simbol harmoni antara kehidupan masyarakat Bali dengan samudra yang luas.

Asal Usul Pembangunan
Pura ini dibangun oleh Dang Hyang Nirartha pada abad ke-16 setelah beliau merasakan getaran spiritual yang kuat di tempat ini. Pura dibangun menghadap laut untuk memuja Dewa Baruna (Dewa Laut) dan berfungsi sebagai pelindung spiritual pulau Bali.

Struktur Tanah Lot sangat unik karena aksesnya tertutup air saat pasang, menjadikannya terbagi dalam tiga zona pengalaman mistis.

Zona 1 : Pura Utama
Bangunan suci di atas batu karang besar yang melambangkan keteguhan iman umat Hindu Bali di tengah gempuran ombak laut yang keras.

Zona 2 : Gua Ular Suci
Celah di bawah karang yang dihuni ular laut penjaga pura. Zona ini menggambarkan penghormatan manusia terhadap keseimbangan makhluk hidup di alam semesta.

Zona 3 : Pelataran Matahari Terbenam
Area tebing pantai untuk menyaksikan siluet pura saat sunset. Pemandangan ini menggambarkan kedamaian spiritual dan keindahan ciptaan Tuhan yang tiada tara.

Nikmati pengalaman berkunjung di Tanah Lot secara langsung digenggamanmu!''',
    },
    {
      'title': 'Bukittinggi',
      'category': 'HISTORY',
      'location': 'SUMATRA',
      'fact': 'Home to the iconic Jam Gadang clock.',
      'imageUrl': 'assets/Bukittinggi.jpg',
      'description': '''Pesona Sejarah Bukittinggi
Bukittinggi adalah kota bersejarah di Sumatera Barat yang dikelilingi pegunungan. Dikenal dengan arsitektur ikoniknya, kota ini merupakan pusat kebudayaan Minangkabau yang menyimpan jejak perjuangan kemerdekaan bangsa.

Asal Usul Pembangunan
Ikon utamanya, Jam Gadang, dibangun pada tahun 1926 sebagai hadiah dari Ratu Belanda. Keunikan jam ini terletak pada angka romawi IIII dan mesin jamnya yang identik dengan Big Ben di London. Kota ini pernah menjadi ibu kota darurat Republik Indonesia.

Bukittinggi memiliki topografi dramatis dengan lembah yang dalam, terbagi menjadi tiga zona yang menyajikan perpaduan sejarah dan alam.

Zona 1 : Jam Gadang
Pusat kota dan simbol identitas Minangkabau. Arsitektur atapnya yang bergaya Rumah Gadang mencerminkan martabat dan kehormatan budaya lokal yang tinggi.

Zona 2 : Lobang Jepang
Terowongan pertahanan bawah tanah yang dibangun pada masa Perang Dunia II. Zona ini menggambarkan sisi gelap sejarah dan ketahanan fisik manusia dalam kondisi ekstrem.

Zona 3 : Ngarai Sianok
Lembah curam yang indah dengan pemandangan pegunungan. Zona ini menyajikan ketenangan alam yang kontras dengan hiruk pikuk sejarah di pusat kota.

Nikmati pengalaman berkunjung di Bukittinggi secara langsung digenggamanmu!''',
    },
    {
      'title': 'Banda Neira',
      'category': 'HISTORY',
      'location': 'MALUKU',
      'fact': 'The historic center of the global spice trade.',
      'imageUrl': 'assets/Banda_Neira.jpg',
      'description': '''Jejak Jalur Rempah Banda Neira
Banda Neira adalah pulau kecil di Maluku yang pernah menjadi satu-satunya sumber buah Pala di dunia. Sejarahnya sangat signifikan karena menjadi pusat perebutan kekuasaan bangsa-bangsa Eropa pada masa lalu.

Asal Usul dan Sejarah
Pada abad ke-17, pala lebih berharga daripada emas, menjadikan Banda Neira sebagai "Jalur Rempah" yang legendaris. Pulau ini juga menjadi saksi perjuangan kemerdekaan sebagai tempat pengasingan tokoh bangsa seperti Mohammad Hatta.

Lanskap Banda Neira didominasi bangunan kolonial dan gunung api, terbagi dalam tiga zona pengalaman sejarah yang mendalam.

Zona 1 : Kota Tua Kolonial
Area peninggalan Belanda yang dipenuhi bangunan klasik. Zona ini mencerminkan masa kejayaan perdagangan dunia yang pernah berpusat di pulau kecil ini.

Zona 2 : Benteng Belgica
Benteng pertahanan VOC berbentuk segi lima yang megah. Dari atas benteng ini terlihat seluruh kepulauan, menggambarkan strategi pengawasan militer masa lampau.

Zona 3 : Taman Laut dan Gunung Api
Keanekaragaman bawah laut yang spektakuler di kaki Gunung Api Banda. Zona ini menggambarkan ketangguhan alam dalam memulihkan kehidupan setelah letusan vulkanik.

Nikmati pengalaman berkunjung di Banda Neira secara langsung digenggamanmu!''',
    },
    {
      'title': 'Taman Nasional Bunaken',
      'category': 'NATURE',
      'location': 'MANADO',
      'fact':
          'Known for having 70% of all known fish species in the Indo-Western Pacific.',
      'imageUrl': 'assets/Bunaken.jpg',
      'description': '''Sejarah Taman Nasional Bunaken
Bunaken adalah salah satu taman laut tertua di Indonesia yang terletak di Sulawesi Utara. Dikenal sebagai simbol keanekaragaman hayati laut dunia, Bunaken memiliki ekosistem yang luar biasa megah yang tercermin dalam dinding-dinding karang raksasanya.

Asal Usul dan Status
Kawasan ini ditemukan oleh para penyelam lokal dan peneliti pada tahun 1970-an sebelum akhirnya resmi ditetapkan sebagai Taman Nasional pada tahun 1991. Bunaken merupakan bagian dari Segitiga Terumbu Karang dunia. Tempat ini menjadi pusat konservasi bagi ratusan jenis moluska, mamalia laut, dan reptil. Keberadaan pulau-pulau di sini memberikan perlindungan bagi arus laut yang kaya akan nutrisi, menjadikannya surga bagi para pecinta bawah laut.

Bentang alam Bunaken didominasi oleh perairan dalam dan pulau-pulau kecil vulkanik. Wilayah ini terbagi menjadi tiga zona eksplorasi yang menggambarkan kekayaan ekosistem maritim.

Zona 1 : Bunaken Mainland
Pusat aktivitas menyelam yang memiliki dinding karang vertikal setinggi 25-50 meter. Di sini pengunjung dapat menyaksikan ribuan ikan hias yang menari di antara sela-sela terumbu karang yang sehat.

Zona 2 : Pulau Manado Tua
Bekas gunung api non-aktif yang menjulang dari dasar laut. Zona ini melambangkan kekuatan geologi masa lalu yang kini menjadi rumah bagi satwa darat seperti monyet hitam Sulawesi dan berbagai jenis burung eksotis.

Zona 3 : Pulau Siladen
Pulau dengan hamparan pasir putih yang luas dan perairan dangkal yang jernih. Zona ini menggambarkan ketenangan dan kemurnian alam, ideal bagi mereka yang ingin menikmati snorkeling dengan santai.

Nikmati pengalaman berkunjung di Bunaken secara langsung digenggamanmu!''',
    },
    {
      'title': 'Gunung Semeru',
      'category': 'NATURE',
      'location': 'JAVA',
      'fact': 'The highest mountain on the island of Java.',
      'imageUrl': 'assets/Semeru.jpg',
      'description': '''Kemegahan Gunung Semeru
Gunung Semeru atau Mahameru adalah puncak tertinggi di Pulau Jawa yang terletak di Jawa Timur. Dikenal sebagai gunung suci bagi masyarakat Jawa, Semeru memiliki sejarah geologi dan spiritual yang sangat dalam bagi penduduk setempat.

Asal Usul dan Legenda
Dalam kosmologi Hindu-Jawa, Semeru diyakini sebagai paku bumi yang dipindahkan dari India untuk memantapkan posisi Pulau Jawa. Gunung ini merupakan gunung api aktif yang terus mengeluarkan abu vulkanik setiap beberapa menit (wedhus gembel). Peninggalan spiritual ini menjadi magnet bagi para pendaki yang ingin merasakan tantangan fisik sekaligus kedekatan dengan alam semesta.

Kawasan Semeru merupakan bagian dari Taman Nasional Bromo Tengger Semeru. Jalur pendakiannya terbagi menjadi tiga zona yang sangat ikonik dan menguras emosi.

Zona 1 : Ranu Kumbolo
Danau air tawar di ketinggian 2.400 mdpl yang menjadi tempat berkemah bagi para pendaki. Zona ini melambangkan ketenangan jiwa sebelum menghadapi tantangan puncak yang sebenarnya.

Zona 2 : Oro-oro Ombo
Hamparan padang sabana yang dipenuhi oleh bunga Verbena yang indah. Zona ini menggambarkan luasnya alam liar yang harus diarungi manusia dengan penuh rasa hormat.

Zona 3 : Puncak Mahameru
Titik tertinggi di 3.676 mdpl yang sangat menantang dengan medan pasir terjal. Mencapai puncak ini adalah simbol pencerahan dan kemenangan atas diri sendiri di hadapan kekuasaan Tuhan.

Nikmati pengalaman berkunjung di Gunung Semeru secara langsung digenggamanmu!''',
    },
    {
      'title': 'Kepulauan Derawan',
      'category': 'NATURE',
      'location': 'KALIMANTAN',
      'fact': 'The largest green turtle nesting site in Indonesia.',
      'imageUrl': 'assets/Derawan.jpg',
      'description': '''Pesona Kepulauan Derawan
Kepulauan Derawan di Kalimantan Timur adalah salah satu destinasi wisata bahari paling eksotis di dunia. Dikenal sebagai rumah bagi satwa langka, Derawan menawarkan keajaiban alam yang tak ditemukan di tempat lain.

Asal Usul dan Status
Kawasan ini mulai dikembangkan secara serius pada awal tahun 2000-an seiring dengan meningkatnya minat dunia terhadap ekowisata. Derawan memiliki ekosistem padang lamun, hutan bakau, dan terumbu karang yang sangat luas. Pulau-pulau di sini merupakan situs peneluran penyu hijau terbesar di Indonesia, menjadikannya laboratorium alam yang sangat penting bagi konservasi laut global.

Kepulauan ini terdiri dari beberapa pulau utama yang masing-masing memiliki karakter zona unik dan menakjubkan.

Zona 1 : Pulau Kakaban
Pulau dengan danau purba di tengahnya yang berisi ribuan ubur-ubur tidak menyengat. Zona ini menggambarkan keunikan evolusi di mana ubur-ubur kehilangan kemampuan menyengat karena tak adanya predator.

Zona 2 : Pulau Maratua
Pulau berbentuk huruf "U" dengan laguna yang sangat luas. Di sini pengunjung dapat melihat gerombolan penyu raksasa dan ikan pari yang melintas tepat di bawah penginapan terapung.

Zona 3 : Pulau Sangalaki
Pusat konservasi dan peneluran penyu. Zona ini melambangkan siklus kehidupan yang murni, di mana setiap tahun ribuan bayi penyu (tukik) mulai berjuang mengarungi samudra.

Nikmati pengalaman berkunjung di Kepulauan Derawan secara langsung digenggamanmu!''',
    },
    {
      'title': 'Danau Kelimutu',
      'category': 'NATURE',
      'location': 'FLORES',
      'fact': 'Three separate lakes that change color unpredictably.',
      'imageUrl': 'assets/Kelimutu.jpg',
      'description': '''Misteri Danau Kelimutu
Danau Kelimutu adalah salah satu fenomena geologi paling misterius di dunia yang terletak di puncak Gunung Kelimutu, Flores. Dikenal karena perubahan warna airnya yang tak terduga, danau ini memiliki nilai sakral yang mendalam bagi masyarakat Lio.

Asal Usul dan Kepercayaan
Masyarakat lokal meyakini bahwa Danau Kelimutu adalah tempat bersemayamnya jiwa-jiwa orang yang telah meninggal. Perubahan warna air dianggap sebagai pertanda perubahan alam atau peringatan dari para leluhur. Nama Kelimutu berasal dari kata "Keli" (gunung) dan "Mutu" (mendidih), mencerminkan aktivitas vulkanik yang melahirkan tiga danau berbeda warna ini.

Ketiga danau ini terletak di satu puncak namun memiliki komposisi mineral yang berbeda, menciptakan tiga zona spiritual yang unik.

Zona 1 : Tiwu Ata Polo
Danau yang biasanya berwarna merah atau cokelat tua. Dipercaya sebagai tempat bagi jiwa-jiwa orang yang melakukan kejahatan selama hidupnya.

Zona 2 : Tiwu Nua Muri Koo Fai
Danau yang biasanya berwarna hijau toska atau biru muda. Dipercaya sebagai tempat bagi jiwa muda-mudi yang meninggal sebelum mencapai kedewasaan.

Zona 3 : Tiwu Ata Mbupu
Danau yang biasanya berwarna putih atau biru tua. Dipercaya sebagai tempat bersemayamnya jiwa-jiwa orang tua yang telah menjalani hidup dengan kebijaksanaan.

Nikmati pengalaman berkunjung di Danau Kelimutu secara langsung digenggamanmu!''',
    },
    {
      'title': 'Pantai Tanjung Tinggi',
      'category': 'BEACH',
      'location': 'BELITUNG',
      'fact': 'Famous for its giant granite boulders and white sand.',
      'imageUrl': 'assets/Belitung.jpg',
      'description': '''Eksotisme Pantai Tanjung Tinggi
Pantai Tanjung Tinggi adalah salah satu pantai terindah di Indonesia yang terletak di Pulau Belitung. Dikenal secara internasional melalui film "Laskar Pelangi", pantai ini menawarkan pemandangan batu granit raksasa yang sangat ikonik.

Asal Usul dan Sejarah
Kawasan ini merupakan bagian dari sejarah geologi yang panjang di mana bebatuan granit purba terbentuk di bawah permukaan bumi jutaan tahun lalu dan terangkat ke permukaan akibat proses tektonik. Pantai ini menjadi simbol ketangguhan dan keindahan alam Sumatra. Struktur pantunya yang landai dengan air jernih menjadikannya tempat yang sempurna untuk mengeksplorasi labirin batuan purba.

Bentang alam Tanjung Tinggi terbagi menjadi beberapa zona pengalaman visual yang sangat dramatis.

Zona 1 : Labirin Granit
Area di mana ratusan batu granit raksasa tersusun secara acak membentuk lorong-lorong alami. Zona ini menggambarkan kekuatan alam yang mampu membentuk struktur artistik tanpa campur tangan manusia.

Zona 2 : Pesisir Putih
Garis pantai dengan pasir yang sangat halus dan ombak yang tenang. Zona ini melambangkan kedamaian dan kehangatan khas pesisir Belitung yang menenangkan jiwa.

Zona 3 : Sunset Point
Titik terbaik untuk melihat matahari terbenam di antara celah-celah batu. Gradasi warna langit yang bertemu dengan siluet batu granit menciptakan suasana yang sangat magis dan romantis.

Nikmati pengalaman berkunjung di Tanjung Tinggi secara langsung digenggamanmu!''',
    },
    {
      'title': 'Pura Besakih',
      'category': 'CULTURAL',
      'location': 'BALI',
      'fact': 'Known as the "Mother Temple" of Bali.',
      'imageUrl': 'assets/Besakih.jpg',
      'description': '''Kemegahan Pura Besakih
Pura Besakih adalah kompleks pura terbesar dan paling suci di Bali yang terletak di lereng Gunung Agung. Dikenal sebagai pusat spiritualitas umat Hindu Bali, pura ini mencerminkan kejayaan arsitektur dan keteguhan iman masyarakat setempat.

Asal Usul Pembangunan
Besakih mulai dibangun pada abad ke-8 oleh Rsi Markandeya sebagai tempat pemujaan leluhur. Kompleks ini terdiri dari puluhan pura yang melambangkan kasta dan klan masyarakat Bali. Pura ini tetap berdiri kokoh meskipun Gunung Agung mengalami letusan dahsyat pada tahun 1963, yang diyakini masyarakat sebagai perlindungan dewa.

Struktur Besakih mengikuti konsep Tri Hita Karana, yang membagi kawasan ini menjadi zona-zona spiritual yang menanjak menuju kesucian.

Zona 1 : Pura Penataran Agung
Pura pusat yang paling megah dengan anak tangga yang menjulang tinggi. Zona ini melambangkan pusat peribadatan dan persatuan seluruh umat.

Zona 2 : Pura Basukian
Tempat di mana wahyu pertama diterima oleh para rishi. Zona ini menggambarkan awal mula perjalanan spiritual manusia menuju pencerahan.

Zona 3 : Area Puncak
Titik tertinggi yang berbatasan langsung dengan hutan lereng Gunung Agung. Zona ini melambangkan kemurnian tertinggi dan kedekatan manusia dengan Sang Pencipta.

Nikmati pengalaman berkunjung di Pura Besakih secara langsung digenggamanmu!''',
    },
    {
      'title': 'Benteng Marlborough',
      'category': 'HISTORY',
      'location': 'BENGKULU',
      'fact': 'The strongest British fort in the East.',
      'imageUrl': 'assets/Marlborough.jpg',
      'description': '''Sejarah Benteng Marlborough
Fort Marlborough adalah peninggalan kolonial Inggris terbesar di Asia Tenggara yang terletak di Bengkulu. Dikenal sebagai simbol kekuatan militer masa lampau, benteng ini memiliki arsitektur yang sangat kokoh dan masih terjaga keasliannya.

Asal Usul Pembangunan
EIC (East India Company) membangun benteng ini antara tahun 1714-1719 pada masa pemerintahan Gubernur Joseph Collett. Benteng ini dinamakan untuk menghormati jenderal Inggris terkenal, John Churchill (Duke of Marlborough). Tempat ini dulunya berfungsi sebagai pusat perdagangan rempah-rempah dan pertahanan militer Inggris di pantai barat Sumatra sebelum akhirnya diserahkan ke Belanda melalui Traktat London.

Benteng ini memiliki bentuk seperti kura-kura jika dilihat dari atas, terbagi dalam zona-zona fungsional yang menceritakan sejarah kolonialisme.

Zona 1 : Bastion dan Meriam
Dinding luar yang tebal dengan meriam-meriam yang masih mengarah ke laut. Zona ini menggambarkan kewaspadaan dan kekuatan pertahanan maritim masa lalu.

Zona 2 : Ruang Tahanan dan Gudang
Area bawah tanah yang dingin dan lembap. Zona ini menyimpan memori tentang perjuangan dan kerasnya kehidupan di masa peperangan.

Zona 3 : Pelataran Atas
Bagian atap benteng yang luas dengan pemandangan Samudra Hindia. Zona ini kini menjadi ruang publik untuk menikmati keindahan pantai Bengkulu sambil meresapi jejak sejarah.

Nikmati pengalaman berkunjung di Fort Marlborough secara langsung digenggamanmu!''',
    },
    {
      'title': 'Danau Linow',
      'category': 'NATURE',
      'location': 'MANADO',
      'fact': 'Known for its changing colors due to sulfur content.',
      'imageUrl': 'assets/Linow.jpg',
      'description': '''Keajaiban Danau Linow
Danau Linow adalah sebuah danau sulfur yang terletak di Tomohon, Sulawesi Utara. Dikenal karena airnya yang dapat berubah menjadi tiga warna hijau, biru, dan kuning kecokelatan yang menawarkan pemandangan yang sangat unik.

Asal Usul dan Fenomena
Nama Linow berasal dari kata "Lilinowan" yang berarti tempat berkumpulnya air. Danau ini terbentuk dari aktivitas vulkanik pasca letusan ribuan tahun lalu. Kandungan belerang yang sangat tinggi di dalam danau bereaksi dengan pantulan cahaya matahari, menciptakan gradasi warna yang menakjubkan. Suasana di sini sangat tenang dengan udara pegunungan yang sejuk.

Kawasan Linow tertata sangat rapi dan terbagi menjadi beberapa zona santai untuk menikmati keajaiban kimia alam ini.

Zona 1 : Tepi Danau (Area Cafe)
Tempat di mana pengunjung dapat duduk bersantai sambil memandangi perubahan warna air. Zona ini menggambarkan harmoni antara kenyamanan manusia dengan fenomena alam yang dinamis.

Zona 2 : Jalur Pipa Panas Bumi
Area di sekitar danau yang menunjukkan aktivitas geotermal aktif. Di sini pengunjung dapat melihat uap air panas yang keluar dari perut bumi, pengingat akan kekuatan vulkanik Minahasa.

Zona 3 : Bukit Sekitar
Titik pandang dari ketinggian yang memberikan perspektif utuh tentang bentuk danau. Zona ini melambangkan kejernihan pikiran saat memandang keindahan dari sudut yang lebih luas.

Nikmati pengalaman berkunjung di Danau Linow secara langsung digenggamanmu!''',
    },
    {
      'title': 'Pantai Ora',
      'category': 'BEACH',
      'location': 'MALUKU',
      'fact': 'Often called the "Maldives of Indonesia".',
      'imageUrl': 'assets/Ora.jpg',
      'description': '''Surga Tersembunyi Pantai Ora
Pantai Ora adalah sebuah destinasi wisata tersembunyi yang terletak di Pulau Seram, Maluku. Dikenal dengan resor terapungnya yang menyerupai Maladewa, Ora menawarkan kedamaian yang tak tertandingi jauh dari keramaian kota.

Asal Usul dan Keunikan
Pantai Ora mulai dikenal luas sebagai destinasi bulan madu utama karena airnya yang sangat tenang dan bening seperti kaca. Terletak di Teluk Sawai yang dikelilingi oleh tebing-tebing kapur raksasa dari Taman Nasional Manusela. Kejernihan air di sini memungkinkan pengunjung untuk melihat terumbu karang tepat di bawah lantai kamar mereka tanpa perlu menyelam dalam.

Zona keindahan di Ora mencerminkan kemurnian alam Maluku yang masih sangat terjaga.

Zona 1 : Resor Terapung
Deretan penginapan kayu di atas air yang menyatu dengan ekosistem laut. Zona ini melambangkan gaya hidup manusia yang hidup berdampingan dengan laut tanpa merusaknya.

Zona 2 : Tebing Batu Sawai
Dinding kapur vertikal yang menjulang dari dasar laut. Zona ini menggambarkan kemegahan geologi yang melindungi teluk dari ombak besar samudra.

Zona 3 : Mata Air Belanda
Sumber air tawar yang muncul di tepi pantai asin. Zona ini menggambarkan keunikan hidrologi dan keberlimpahan sumber daya alam di pedalaman Seram.

Nikmati pengalaman berkunjung di Pantai Ora secara langsung digenggamanmu!''',
    },
    {
      'title': 'Pulau Weh',
      'category': 'ISLAND',
      'location': 'SABANG',
      'fact': 'The westernmost point of Indonesia.',
      'imageUrl': 'assets/Pulau_Weh.jpg',
      'description': '''Ujung Barat Indonesia: Pulau Weh
Pulau Weh atau Sabang adalah titik nol kilometer Indonesia yang terletak di Provinsi Aceh. Dikenal sebagai gerbang barat nusantara, pulau ini memiliki keindahan bawah laut yang luar biasa dan sejarah maritim yang sangat kuat.

Asal Usul dan Peran
Sabang dulunya merupakan pelabuhan bebas yang sangat ramai dikunjungi kapal-kapal internasional di Selat Malaka. Pulau ini dipisahkan dari daratan Sumatra melalui aktivitas seismik ribuan tahun lalu. Selain sejarahnya, Pulau Weh merupakan destinasi selam kelas dunia dengan keberadaan bangkai kapal perang di dasar laut dan keanekaragaman hayati yang sangat tinggi.

Struktur wisata Pulau Weh terbagi menjadi zona-zona yang memadukan sejarah bangsa dengan keajaiban samudra.

Zona 1 : Kota Sabang
Pusat sejarah dengan bangunan-bangunan kolonial yang masih terawat. Zona ini mencerminkan masa kejayaan perdagangan di ujung barat Indonesia.

Zona 2 : Pantai Iboih & Pulau Rubiah
Pusat aktivitas snorkeling dan diving. Zona ini menggambarkan kekayaan ekosistem bawah laut yang menjadi paru-paru biru bagi wilayah Aceh.

Zona 3 : Tugu Nol Kilometer
Monumen paling barat yang melambangkan persatuan bangsa. Berdiri di sini memberikan perasaan bangga akan luasnya nusantara dari Sabang sampai Merauke.

Nikmati pengalaman berkunjung di Pulau Weh secara langsung digenggamanmu!''',
    },
    {
      'title': 'Desa Penglipuran',
      'category': 'CULTURAL',
      'location': 'BALI',
      'fact': 'Recognized as one of the cleanest villages in the world.',
      'imageUrl': 'assets/Penglipuran.jpg',
      'description': '''Kearifan Desa Penglipuran
Desa Wisata Penglipuran di Bangli adalah salah satu desa adat paling terkenal di Bali. Dikenal karena kebersihan dan tata ruangnya yang teratur, desa ini merupakan model pelestarian budaya tradisional yang berkelanjutan.

Asal Usul dan Tata Ruang
Nama Penglipuran berasal dari kata "Pengeling Pura" yang berarti tempat mengenang leluhur. Desa ini dibangun berdasarkan konsep "Tri Mandala", sebuah tata ruang yang membagi wilayah menjadi zona utama, madya, dan nista. Keunikan desa ini terletak pada keseragaman arsitektur gerbang rumah (Angkul-angkul) dan larangan masuknya kendaraan bermotor ke area pemukiman utama.

Setiap jengkal tanah di Penglipuran memiliki fungsi sosial dan spiritual yang sangat dalam.

Zona 1 : Area Pemukiman (Madya Mandala)
Jalan setapak utama yang lurus dan bersih dengan deretan taman bunga di depan rumah warga. Zona ini mencerminkan kedisiplinan dan kebersamaan masyarakat dalam menjaga kebersihan lingkungan.

Zona 2 : Hutan Bambu
Hutan seluas 45 hektar yang mengelilingi desa. Zona ini menggambarkan pentingnya pelestarian alam sebagai paru-paru desa dan penyedia bahan baku kerajinan tradisional.

Zona 3 : Pura Penataran (Utama Mandala)
Tempat paling suci di ujung desa. Zona ini melambangkan penghormatan tertinggi kepada dewa-dewa dan leluhur sebagai pelindung desa.

Nikmati pengalaman berkunjung di Penglipuran secara langsung digenggamanmu!''',
    },
    {
      'title': 'Kawah Putih',
      'category': 'NATURE',
      'location': 'JAVA',
      'fact': 'A highly acidic lake created by a volcanic eruption.',
      'imageUrl': 'assets/Kawah_Putih.jpg',
      'description': '''Keindahan Magis Kawah Putih
Kawah Putih adalah sebuah danau kawah yang terletak di Ciwidey, Jawa Barat. Dikenal dengan tanahnya yang berwarna putih akibat bercampur belerang dan airnya yang berwarna hijau keputihan yang memberikan suasana seperti di planet lain.

Asal Usul dan Sejarah
Kawah ini terbentuk dari letusan Gunung Patuha pada abad ke-10. Kawasan ini dulunya dianggap angker karena burung yang terbang di atasnya sering mati mendadak. Pada tahun 1837, seorang peneliti Belanda, Dr. Franz Wilhelm Junghuhn, memberanikan diri naik ke puncak dan menemukan keajaiban ini. Ternyata, kematian burung disebabkan oleh konsentrasi gas belerang yang tinggi, bukan karena hal mistis.

Lanskap Kawah Putih sangat dramatis dengan pepohonan cantigi yang kering, terbagi menjadi beberapa zona pengalaman visual.

Zona 1 : Dermaga Ponton
Jembatan kayu yang menjorok ke tengah danau. Zona ini memberikan kesempatan bagi pengunjung untuk merasakan kedekatan dengan air belerang yang tenang namun panas di bawah permukaan.

Zona 2 : Sunan Ibu (Sunrise Point)
Titik tertinggi untuk melihat matahari terbit di atas kawah. Zona ini melambangkan harapan baru seiring dengan munculnya cahaya dari balik kabut belerang.

Zona 3 : Cantigi Skywalk
Jembatan di atas hutan cantigi yang memberikan pemandangan kawah dari ketinggian. Zona ini menggambarkan ketangguhan flora yang mampu hidup di lingkungan ekstrem.

Nikmati pengalaman berkunjung di Kawah Putih secara langsung digenggamanmu!''',
    },
  ];
}
