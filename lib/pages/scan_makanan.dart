import 'package:flutter/material.dart';

class ScanMakananTab extends StatelessWidget {
  const ScanMakananTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar bagian atas halaman
      appBar: AppBar(
        title: const Text(
          'Scan Kaki',
          style: TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),

      ),

      // Isi halaman bisa di-scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul bagian metode scan
            Text(
              'Pilih Metode Scan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),

            // Dua pilihan: Kamera dan Galeri
            Row(
              children: [
                Expanded(
                  child: _buildScanOption(
                    context,
                    Icons.camera_alt,      // ikon kamera
                    'Kamera',
                    'Ambil foto kaki',
                    () {
                      // Dummy action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tombol Kamera ditekan')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScanOption(
                    context,
                    Icons.photo_library,   // ikon galeri
                    'Galeri',
                    'Pilih dari galeri',
                    () {
                      // Dummy action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tombol Galeri ditekan')),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Placeholder Preview Gambar
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Preview Gambar',
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Kartu Hasil Scan
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Hasil Scan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Placeholder hasil scan (belum ada AI)
                    Center(
                      child: Text(
                        'Hasil scan akan tampil di sini',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget reusable untuk tombol pilihan scan (kamera & galeri)
  Widget _buildScanOption(
    BuildContext context,
    IconData icon,      // ikon (kamera / galeri)
    String title,       // judul (Kamera / Galeri)
    String subtitle,    // deskripsi kecil
    VoidCallback onTap, // fungsi ketika ditekan
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF0077BE)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: ScanMakananTab()));
}
