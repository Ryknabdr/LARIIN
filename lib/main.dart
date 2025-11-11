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

// Custom FAB location that doesn't move with Snackbar
class CustomCenterDockedFloatingActionButtonLocation extends FloatingActionButtonLocation {
  const CustomCenterDockedFloatingActionButtonLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = (scaffoldGeometry.scaffoldSize.width - scaffoldGeometry.floatingActionButtonSize.width) / 2.0;
    final double fabY = scaffoldGeometry.scaffoldSize.height - scaffoldGeometry.floatingActionButtonSize.height / 2.0 - scaffoldGeometry.bottomSheetSize.height;
    return Offset(fabX, fabY);
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget? _initialScreen;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isFirstLaunch) {
      _initialScreen = const OnboardingPage();
    } else if (!isLoggedIn) {
      _initialScreen = const LoginPage();
    } else {
      _initialScreen = const HomePage();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_initialScreen == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      title: 'Lariin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077BE), // Professional blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: GoogleFonts.inter().fontFamily,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          foregroundColor: const Color.fromARGB(255, 44, 41, 216),
          elevation: 0,
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF00B4D8),
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 8,
        ),
        cardTheme: const CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00B4D8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      routes: {
        '/onboarding': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/notifikasi': (context) => const NotifikasiPage(),
        '/event': (context) => const EventPage(),
        '/scan': (context) => const ScanMakananTab(),
        '/chatbot': (context) => const ChatbotGiziTab(),
        '/aktivitas': (context) => const AktivitasPage(),
        '/feedback': (context) => const FeedbackPage(),
        '/manage-profile': (context) => const ManageProfilePage(),
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
    _pages = <Widget>[
      BerandaTab(onTabSwitch: switchToTab),
      const PelacakanLariTab(),
      const ScanMakananTab(),
      const ChatbotGiziTab(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void switchToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                color: _selectedIndex == 0 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(0),
              ),
              IconButton(
                icon: const Icon(Icons.directions_run),
                color: _selectedIndex == 1 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(1),
              ),
              const SizedBox(width: 48), // area buat FAB
              IconButton(
                icon: const Icon(Icons.chat),
                color: _selectedIndex == 3 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(3),
              ),
              IconButton(
                icon: const Icon(Icons.person),
                color: _selectedIndex == 4 ? Colors.lightBlue : Colors.grey,
                onPressed: () => _onItemTapped(4),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: const CustomCenterDockedFloatingActionButtonLocation(),
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