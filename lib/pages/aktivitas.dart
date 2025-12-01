import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AktivitasPage extends StatelessWidget {
  const AktivitasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Semua Aktivitas',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // judul bagian aktivitas
              Text(
                'Riwayat Aktivitas Lari',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),

              const SizedBox(height: 16),

              // list aktivitasnya — scrollable
              Expanded(
                child: ListView(
                  children: [

                    // item aktivitas — tinggal tambah sendiri kalo perlu
                    _buildActivityItem('🏃 Lari sore', '5.2 km – 35 menit', const Color(0xFFFF6B35), 'Hari ini'),
                    _buildActivityItem('🌇 Lari pagi', '3.8 km – 28 menit', const Color(0xFF1E3A8A), 'Kemarin'),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // card item aktivitas — biar ga nulis ulang terus
  Widget _buildActivityItem(String title, String subtitle, Color color, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // shadow halus biar cardnya keliatan terangkat
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

          // teks kiri (judul, jarak, tanggal)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // judul + emoji
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: color, // warna beda biar mudah dibedain
                  ),
                ),

                const SizedBox(height: 4),

                // info jarak & durasi
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 4),

                // tanggal aktivitas
                Text(
                  date,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          // // ikon next — cuma dekor
          // const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
