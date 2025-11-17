import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _feedbackController = TextEditingController();
  int _selectedRating = 0;

  void _submitFeedback() {
    // cek dulu isi feedback kosong apa nggak
    if (_feedbackController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon isi feedback Anda'), duration: Duration(seconds: 2)),
      );
      return;
    }

    // cek rating dipilih atau belum
    if (_selectedRating  == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon berikan rating'), duration: Duration(seconds: 2)),
      );
      return;
    }

    // nanti logic kirim ke backend di sini
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Terima kasih atas feedback Anda!'), duration: Duration(seconds: 2)),
    );

    // reset form setelah submit
    _feedbackController.clear();
    setState(() {
      _selectedRating = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Feedback',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // judul utama halaman feedback
            Text(
              'Bagaimana pengalaman Anda menggunakan Lariin?',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E3A8A),
              ),
            ),

            const SizedBox(height: 24),

            // bagian rating
            Text(
              'Beri Rating',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 12),

            // bintang rating — tinggal klik, langsung ke-set
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedRating = index + 1; // set bintang sesuai klik
                    });
                  },
                  icon: Icon(
                    index < _selectedRating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFF6B35),
                    size: 32,
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // input text feedback
            Text(
              'Tulis Feedback Anda',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 12),

            // box input feedback — desain card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  // shadow biar keliatan angkat
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: 'Ceritakan pengalaman Anda...',
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.grey[400],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none, // bersih tanpa garis
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: GoogleFonts.poppins(),
              ),
            ),

            const SizedBox(height: 24),

            // pilihan kategori chip (tinggal klik langsung nambah ke text)
            Text(
              'Atau pilih kategori feedback:',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 12),

            // chip kategori — bisa pilih cepat tanpa nulis
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFeedbackChip('Fitur Bagus'),
                _buildFeedbackChip('Perlu Perbaikan'),
                _buildFeedbackChip('Bug Ditemukan'),
                _buildFeedbackChip('Sarankan Fitur'),
                _buildFeedbackChip('Lainnya'),
              ],
            ),

            const SizedBox(height: 32),

            // tombol submit
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _submitFeedback, // trigger fungsi submit
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: const Color(0xFF1E3A8A).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Kirim Feedback',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // builder untuk chip kategori — klik langsung auto nambah text
  Widget _buildFeedbackChip(String label) {
    return FilterChip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.grey[700],
        ),
      ),
      selected: false, // ga pakai mode multi select, cuma nambah text
      onSelected: (selected) {
        // nambah label ke textfield saat chip diklik
        _feedbackController.text += '$label ';
      },
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey[300]!),
      ),
    );
  }
}
