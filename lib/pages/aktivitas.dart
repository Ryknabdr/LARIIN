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
              Text(
                'Riwayat Aktivitas Lari',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildActivityItem('🏃 Lari sore', '5.2 km – 35 menit', const Color(0xFFFF6B35), 'Hari ini'),
                    _buildActivityItem('🌇 Lari pagi', '3.8 km – 28 menit', const Color(0xFF1E3A8A), 'Kemarin'),
                    _buildActivityItem('🏃 Lari malam', '4.5 km – 32 menit', const Color(0xFFFF6B35), '2 hari lalu'),
                    _buildActivityItem('🌅 Lari pagi', '6.0 km – 42 menit', const Color(0xFF1E3A8A), '3 hari lalu'),
                    _buildActivityItem('🏃 Lari sore', '4.2 km – 30 menit', const Color(0xFFFF6B35), '4 hari lalu'),
                    _buildActivityItem('🌇 Lari pagi', '5.5 km – 38 menit', const Color(0xFF1E3A8A), '5 hari lalu'),
                    _buildActivityItem('🏃 Lari malam', '3.9 km – 29 menit', const Color(0xFFFF6B35), '6 hari lalu'),
                    _buildActivityItem('🌅 Lari pagi', '4.8 km – 35 menit', const Color(0xFF1E3A8A), '7 hari lalu'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, Color color, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                const SizedBox(height: 4),
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
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
