import 'package:flutter/material.dart';

class PelacakanLariTab extends StatelessWidget {
  const PelacakanLariTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pelacakan Lari',
          style: TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF1E3A8A)),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),

      body: Column(
        children: [
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
          // Informasi jarak, durasi, tombol Start/Stop
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Jarak: 0.00 km',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Durasi: 00:00', style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
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

void main() {
  runApp(const MaterialApp(home: PelacakanLariTab()));
}
