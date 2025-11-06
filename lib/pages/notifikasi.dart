import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: const Color.fromARGB(255, 18, 106, 179),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            leading: Icon(Icons.notifications, color: Color(0xFF00B4D8)),
            title: Text('Selamat datang di Lariin!'),
            subtitle: Text('Aplikasi pelacakan lari dan nutrisi Anda.'),
            trailing: Text('Baru'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.directions_run, color: Color(0xFF00B4D8)),
            title: Text('Target Lari Hari Ini'),
            subtitle: Text('Anda telah mencapai 50% dari target harian.'),
            trailing: Text('1 jam lalu'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.restaurant, color: Color(0xFF00B4D8)),
            title: Text('Rekomendasi Nutrisi'),
            subtitle: Text('Coba makanan sehat untuk performa lari yang lebih baik.'),
            trailing: Text('2 jam lalu'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.chat, color: Color(0xFF00B4D8)),
            title: Text('Pesan dari Chatbot Gizi'),
            subtitle: Text('Ada tips nutrisi terbaru untuk Anda.'),
            trailing: Text('Kemarin'),
          ),
        ],
      ),
    );
  }
}
