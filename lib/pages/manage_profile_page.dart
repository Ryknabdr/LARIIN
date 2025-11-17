import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManageProfilePage extends StatelessWidget {
  const ManageProfilePage({super.key});

  // snack bar simpel buat nampilin info "coming soon"
  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature akan segera hadir')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar halaman manage profile
      appBar: AppBar(
        title: Text(
          'Kelola Profil',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E3A8A)),
      ),

      // padding konten utama
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // judul bagian pengaturan profile
            Text(
              'Pengaturan Profil',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 24),

            // card: ubah foto (masih coming soon)
            _buildOptionCard(
              context,
              icon: Icons.photo_camera,
              title: 'Ubah Foto Profil',
              subtitle: 'Pilih foto baru untuk profil Anda',
              onTap: () => _showComingSoonSnackBar(context, 'Ubah Foto Profil'),
            ),
            const SizedBox(height: 16),

            // card ubah password
            _buildOptionCard(
              context,
              icon: Icons.lock,
              title: 'Ubah Kata Sandi',
              subtitle: 'Perbarui kata sandi akun Anda',
              onTap: () => _showComingSoonSnackBar(context, 'Ubah Kata Sandi'),
            ),
            const SizedBox(height: 16),

            // card pengaturan notifikasi
            _buildOptionCard(
              context,
              icon: Icons.notifications,
              title: 'Pengaturan Notifikasi',
              subtitle: 'Kelola preferensi notifikasi',
              onTap: () => _showComingSoonSnackBar(context, 'Pengaturan Notifikasi'),
            ),
          ],
        ),
      ),
    );
  }

  // widget card menu — biar ga ulang-ulang UI
  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap, // klik → ngejalanin fungsi
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            // efek shadow biar keliatan lebih modern
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
            // icon sebelah kiri
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF00B4D8), size: 24),
            ),
            const SizedBox(width: 16),

            // teks judul + deskripsi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // icon panah di kanan
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
