import 'package:flutter/material.dart';

// Halaman Pelacakan Lari
class PelacakanLariTab extends StatelessWidget {
  const PelacakanLariTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar judul + tombol setting
      appBar: AppBar(
        title: const Text(
          'Pelacakan Lari',
          style: TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Tombol ke pengaturan (belum ada fungsi)
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1E3A8A)),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1, // efek bayangan tipis
      ),

      body: Column(
        children: [
          // Bagian map dummy sementara
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                  'Tampilan Map ',
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ),
            ),
          ),

          // Bagian info lari + tombol start
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tampilan jarak
                  const Text(
                    'Jarak: 0.00 km',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  // Tampilan durasi
                  const Text('Durasi: 00:00', style: TextStyle(fontSize: 18)),

                  const SizedBox(height: 20),

                  // Tombol mulai tracking
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor:Colors.white,
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text('Start'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Untuk testing mandiri halaman ini saja
void main() {
  runApp(const MaterialApp(home: PelacakanLariTab()));
}
