import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Halaman Notifikasi, ini tempat semua notif bakal muncul
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar warna putih biar clean
        elevation: 1, // Dikasih sedikit shadow biar gak flat banget
        title: const Text(
          'Notifikasi',
          style: TextStyle(
            color: Color(0xFF1E3A8A), // Warna biru tua, sama kayak tema app
            fontWeight: FontWeight.bold, // Biar judulnya keliatan tegas
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF1E3A8A), // Warna icon back disamain, biar serasi
        ),
      ),

      // Body utama yang nampilin list notif
      body: ListView(
        padding: const EdgeInsets.all(16), // Padding biar gak mepet pinggir
        children: const [
          // --- Notif 1: Sambutan pas user buka aplikasi pertama kali
          ListTile(
            leading: Icon(Icons.notifications, color: Color(0xFF00B4D8)), // Icon biru muda
            title: Text('Selamat datang di Lariin!'), // Judul notif
            subtitle: Text('Aplikasi pelacakan lari dan nutrisi Anda.'), // Info singkat
            trailing: Text('Baru'), // Waktu notif
          ),
          Divider(), // Garis pemisah antar notif

          // --- Notif 2: Pencapaian target lari harian
          ListTile(
            leading: Icon(Icons.directions_run, color: Color(0xFF00B4D8)),
            title: Text('Target Lari Hari Ini'),
            subtitle: Text('Anda telah mencapai 50% dari target harian.'), // Notif progres
            trailing: Text('1 jam lalu'), // Timestamp
          ),
          Divider(),

          // --- Notif 3: Rekomendasi makanan sehat
          ListTile(
            leading: Icon(Icons.restaurant, color: Color(0xFF00B4D8)),
            title: Text('Rekomendasi Nutrisi'),
            subtitle: Text('Coba makanan sehat untuk performa lari yang lebih baik.'), // Tips makan
            trailing: Text('2 jam lalu'),
          ),
          Divider(),

          // --- Notif 4: Pesan dari chatbot gizi
          ListTile(
            leading: Icon(Icons.chat, color: Color(0xFF00B4D8)),
            title: Text('Pesan dari Chatbot Gizi'),
            subtitle: Text('Ada tips nutrisi terbaru untuk Anda.'), // Info dari chatbot
            trailing: Text('Kemarin'),
          ),
        ],
      ),
    );
  }
}
