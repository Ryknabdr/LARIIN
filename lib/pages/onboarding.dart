import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _completeOnboarding(BuildContext context) async {
    // Fungsi buat nandain kalo onboarding udah selesai
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false); // Diset biar next buka nggak balik ke onboarding lagi
    Navigator.pushReplacementNamed(context, '/login'); // Langsung pindah ke halaman login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Isi halaman onboarding
      body: Padding(
        padding: const EdgeInsets.all(40.0), // Padding biar konten gak mepet
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Konten dibikin ke tengah semua
          children: [
            const Text(
              '🏃‍♂️', // Icon lari biar keliatan fun
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(height: 40),

            // Judul utama onboarding
            const Text(
              'Selamat Datang di Lariin',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Warna judul biar keliatan fresh
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Text penjelasan singkat tentang aplikasi
            const Text(
              'Aplikasi ini membantu Anda menjalani gaya hidup sehat, '
              'melacak aktivitas lari, memindai makanan, dan mendapatkan saran gizi secara instan.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Tombol mulai buat nutup onboarding
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _completeOnboarding(context), // Klik tombol, onboarding kelar
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Warna tombol
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Tombol rounded biar lebih smooth
                  ),
                ),
                child: const Text(
                  'Mulai', // Text tombol
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
