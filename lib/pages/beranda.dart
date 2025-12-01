import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BerandaTab extends StatelessWidget {
  final Function(int)? onTabSwitch;

  const BerandaTab({super.key, this.onTabSwitch});

  @override
  Widget build(BuildContext context) {
    final events = [
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

    return Scaffold(
      resizeToAvoidBottomInset: false,

      // ------------------ APP BAR BARU ------------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Selamat Datang, Abdul 👋',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF1E3A8A),
            ),
            onPressed: () => Navigator.pushNamed(context, '/notifikasi'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // ---------------------------------------------------

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // WEEKLY STATS
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: _boxDecoration(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _statItem('Total Jarak', '12.5 km'),
                          _statItem('Total Waktu', '2h 15m'),
                          _statItem('Rata-rata Pace', '6:30 /km'),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // EVENT SLIDER
                CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                  items: events.map((event) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: _boxDecoration(),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.asset(
                              event['image']!,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
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
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
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

                Center(
                  child: TextButton(
                    onPressed: () => Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamed('/event'),
                    child: Text(
                      'Lihat Selengkapnya →',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF1E3A8A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // AI RECOMMENDATION
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
                      child: _aiCard(
                        context,
                        '👟 AI FootScan',
                        'Lihat rekomendasi sepatu terbaik sesuai bentuk kakimu.',
                        const Color(0xFF1E3A8A),
                        () => onTabSwitch?.call(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _aiCard(
                        context,
                        '🤖 AI Run Coach',
                        'Lihat latihan yang disarankan minggu ini.',
                        const Color(0xFFFF6B35),
                        () => onTabSwitch?.call(3),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // RECENT ACTIVITY
                Text(
                  'Aktivitas Terbaru',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 16),

                _activityItem(
                  '🏃 Lari sore',
                  '5.2 km – 35 menit',
                  const Color(0xFFFF6B35),
                ),
                const SizedBox(height: 10),

                _activityItem(
                  '🌇 Lari pagi',
                  '3.8 km – 28 menit',
                  const Color(0xFF1E3A8A),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamed('/aktivitas'),
                  child: Text(
                    'Lihat Semua Aktivitas',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF1E3A8A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // QUOTE
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: _boxDecoration(),
                  child: Center(
                    child: Text(
                      '🏁 Lari bukan soal cepat, tapi soal konsisten.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // staistik

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
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
// AI
  Widget _aiCard(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
    VoidCallback onPressed,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
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
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Coba Sekarang',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

// akitivitas
 Widget _activityItem(String title, String subtitle, Color color) {
  return Container(
    width: double.infinity, 
    padding: const EdgeInsets.all(16),
    decoration: _boxDecoration(),
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
  );
}


// Styling card
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
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
    );
  }
}
