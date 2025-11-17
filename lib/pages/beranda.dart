import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'event_page.dart';
import '../main.dart';

class BerandaTab extends StatelessWidget {
  final Function(int)? onTabSwitch;

  const BerandaTab({super.key, this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // biar ga naik turun pas keyboard buka
      body: SafeArea(
        child: SingleChildScrollView( // biar bisa scroll
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header bagian atas
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Selamat Datang, Abdul 👋',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Color(0xFF1E3A8A)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/notifikasi'); // buka notif
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                _buildWeeklyStats(), // card statistik
                const SizedBox(height: 20),

                _buildEventSlider(context), // slider event
                const SizedBox(height: 20),

                _buildAIRecommendations(context), // fitur AI
                const SizedBox(height: 20),

                _buildRecentActivities(context), // list aktivitas
                const SizedBox(height: 20),

                _buildMotivationalQuote(), // quote motivasi
              ],
            ),
          ),
        ),
      ),
    );
  }

  // slider event
  Widget _buildEventSlider(BuildContext context) {
    final List<Map<String, String>> events = [
      {
        'title': 'Jakarta Run 10K',
        'date': '24 Nov 2025',
        'location': 'Jakarta',
        'distance': '10K',
        'image': 'assets/images/pancalrun.jpeg',
      },
      {
        'title': 'Morning Run Challenge',
        'date': '15 Dec 2025',
        'location': 'Bandung',
        'distance': '5K',
        'image': 'assets/images/railfuns.jpeg',
      },
      {
        'title': 'Virtual Run – Beat Your Record',
        'date': '1 Jan 2026',
        'location': 'Online',
        'distance': '10K',
        'image': 'assets/images/pancalrun.jpeg',
      },
    ];

    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
            autoPlay: true, // auto jalan
            enlargeCenterPage: true,
            viewportFraction: 0.9,
          ),
          items: events.map((event) {
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // rounding
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2), // shadow bawah
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // gambar event
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      event['image']!,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),

                  // text event
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event['title']!,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${event['date']} • ${event['location']}',
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 10),

        // tombol lihat semua event
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamed('/event');
          },
          child: Text(
            'Lihat Selengkapnya →',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF1E3A8A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // card statistik
  Widget _buildWeeklyStats() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Mingguan',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E3A8A),
            ),
          ),

          const SizedBox(height: 16),

          // 3 data stat
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Total Jarak', '12.5 km'),
              _buildStatItem('Total Waktu', '2h 15m'),
              _buildStatItem('Rata-rata Pace', '6:30 /km'),
            ],
          ),
        ],
      ),
    );
  }

  // item stat satuan
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // list aktivitas terakhir
  Widget _buildRecentActivities(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Aktivitas Terbaru',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),

        const SizedBox(height: 16),

        _buildActivityItem('🏃 Lari sore', '5.2 km – 35 menit', const Color(0xFFFF6B35)),
        _buildActivityItem('🌇 Lari pagi', '3.8 km – 28 menit', const Color(0xFF1E3A8A)),

        const SizedBox(height: 12),

        // tombol lihat semua aktivitas
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushNamed('/aktivitas');
          },
          child: Text(
            'Lihat Semua Aktivitas',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: const Color(0xFF1E3A8A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // satuan aktivitas
  Widget _buildActivityItem(String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // text kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // panah kanan
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  // card fitur AI
  Widget _buildAIRecommendations(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rekomendasi AI',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildAICard(
                context,
                '👟 AI FootScan',
                'Lihat rekomendasi sepatu terbaik sesuai bentuk kakimu.',
                const Color(0xFF1E3A8A),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildAICard(
                context,
                '🤖 AI Run Coach',
                'Lihat latihan yang disarankan minggu ini.',
                const Color(0xFFFF6B35),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // card kecil AI
  Widget _buildAICard(BuildContext context, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            subtitle,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),

          const SizedBox(height: 12),

          // tombol coba AI
          ElevatedButton(
            onPressed: () {
              if (title.contains('FootScan')) {
                onTabSwitch?.call(2); // buka tab scan
              } else if (title.contains('Run Coach')) {
                onTabSwitch?.call(3); // buka chatbot
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              'Coba Sekarang',
              style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // card quote motivasi
  Widget _buildMotivationalQuote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '🏁 Lari bukan soal cepat, tapi soal konsisten.',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E3A8A),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
