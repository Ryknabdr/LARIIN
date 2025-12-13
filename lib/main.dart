import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

// Posisi FAB biar pas di tengah bawah
class CustomCenterDockedFloatingActionButtonLocation
    extends FloatingActionButtonLocation {
  const CustomCenterDockedFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry g) {
    final fabX =
        (g.scaffoldSize.width - g.floatingActionButtonSize.width) / 2;
    final fabY = g.scaffoldSize.height -
        g.floatingActionButtonSize.height / 0.7 -
        g.bottomSheetSize.height;
    return Offset(fabX, fabY);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: memastikan GoogleSignIn bersih
  // await GoogleSignIn().signOut();

  runApp(const MyApp());
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

  // cek apakah pertama kali buka / sudah login / Google login
  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final isGoogleLogin = prefs.getBool('isGoogleLogin') ?? false;

    if (isFirstLaunch) {
      _initialScreen = const OnboardingPage();
    } else if (!isLoggedIn) {
      _initialScreen = const LoginPage();
    } else {
      // kalau login via Google → cek token Google apakah masih valid
      if (isGoogleLogin) {
        final googleUser = await GoogleSignIn().signInSilently();
        if (googleUser == null) {
          // token invalid → kembali ke login
          prefs.setBool('isLoggedIn', false);
          _initialScreen = const LoginPage();
        } else {
          _initialScreen = const HomePage();
        }
      } else {
        _initialScreen = const HomePage();
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // loading sementara
    if (_initialScreen == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: 'Lariin',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
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

      home: _initialScreen,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // daftar tab di bawah
    _pages = [
      BerandaTab(onTabSwitch: switchToTab),
      const PelacakanLariTab(),
      const ScanMakananTab(),
      const ChatbotGiziTab(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void switchToTab(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color:
                    _selectedIndex == 0 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(0),
              ),

              IconButton(
                icon: const Icon(Icons.directions_run),
                color:
                    _selectedIndex == 1 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(1),
              ),

              const SizedBox(width: 48),

              IconButton(
                icon: const Icon(Icons.chat),
                color:
                    _selectedIndex == 3 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(3),
              ),

              IconButton(
                icon: const Icon(Icons.person),
                color:
                    _selectedIndex == 4 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),

      floatingActionButtonLocation:
          const CustomCenterDockedFloatingActionButtonLocation(),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          elevation: 8,
          shape: const CircleBorder(),
          onPressed: () => _onItemTapped(2),
          child: const Icon(Icons.camera_alt, size: 40),
        ),
      ),
    );
  }
}
