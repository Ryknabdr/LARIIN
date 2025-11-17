import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/beranda.dart';
import 'pages/pelacakan_lari.dart';
import 'pages/scan_makanan.dart';
import 'pages/chatbot_gizi.dart';
import 'pages/profil.dart';
import 'pages/onboarding.dart';
import 'pages/login.dart';
import 'pages/register.dart';
import 'pages/notifikasi.dart';
import 'pages/event_page.dart';
import 'pages/aktivitas.dart';
import 'pages/feedback_page.dart';
import 'pages/manage_profile_page.dart';

// posisi FAB biar pas di tengah bawah
class CustomCenterDockedFloatingActionButtonLocation extends FloatingActionButtonLocation {
  const CustomCenterDockedFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry g) {
    final fabX = (g.scaffoldSize.width - g.floatingActionButtonSize.width) / 2;
    final fabY = g.scaffoldSize.height - g.floatingActionButtonSize.height / 0.7 - g.bottomSheetSize.height;
    return Offset(fabX, fabY);
  }
}

void main() {
  runApp(const MyApp()); // mulai app
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _initialScreen; // tampilan awal

  @override
  void initState() {
    super.initState();
    _checkAuthentication(); // cek onboarding/login
  }

  // cek apakah pertama kali buka / sudah login
  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isFirstLaunch) {
      _initialScreen = const OnboardingPage(); // pertama kali
    } else if (!isLoggedIn) {
      _initialScreen = const LoginPage(); // belum login
    } else {
      _initialScreen = const HomePage(); // sudah login
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // loading sebentar
    if (_initialScreen == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Lariin',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily, // font app
      ),

      // route halaman
      routes: {
        '/onboarding': (_) => const OnboardingPage(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/notifikasi': (_) => const NotifikasiPage(),
        '/event': (_) => const EventPage(),
        '/scan': (_) => const ScanMakananTab(),
        '/chatbot': (_) => const ChatbotGiziTab(),
        '/aktivitas': (_) => const AktivitasPage(),
        '/feedback': (_) => const FeedbackPage(),
        '/manage-profile': (_) => const ManageProfilePage(),
      },

      home: _initialScreen, // tampilkan sesuai kondisi
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // index tab

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // list tab yg ada di bottom nav
    _pages = [
      BerandaTab(onTabSwitch: switchToTab),
      const PelacakanLariTab(),
      const ScanMakananTab(),
      const ChatbotGiziTab(),
      const ProfileScreen(),
    ];
  }

  // ganti tab pas klik icon
  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // ganti tab dari beranda
  void switchToTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // tampilin page aktif

      // bottom nav nya
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(), // buat lubang FAB
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // home
              IconButton(
                icon: const Icon(Icons.home),
                color: _selectedIndex == 0 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(0),
              ),

              // running tab
              IconButton(
                icon: const Icon(Icons.directions_run),
                color: _selectedIndex == 1 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(1),
              ),

              const SizedBox(width: 48), // tempat kosong buat FAB

              // chatbot
              IconButton(
                icon: const Icon(Icons.chat),
                color: _selectedIndex == 3 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(3),
              ),

              // profil
              IconButton(
                icon: const Icon(Icons.person),
                color: _selectedIndex == 4 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),

      // tombol besar tengah (kamera)
      floatingActionButtonLocation: const CustomCenterDockedFloatingActionButtonLocation(),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
           elevation: 8,
          shape: const CircleBorder(),
          onPressed: () => _onItemTapped(2), // buka tab scan makanan
          child: const Icon(Icons.camera_alt, size: 40),
        ),
      ),
    );
  }
}
