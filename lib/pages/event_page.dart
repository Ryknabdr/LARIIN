import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  // filter default
  String selectedCity = 'Semua';
  String selectedDistance = 'Semua';
  String selectedTime = 'Semua';

  // data dummy event
  final List<Map<String, String>> events = [
    {
      'title': 'Tegal Run 10K',
      'date': '24 Nov 2025',
      'location': 'Tegal',
      'distance': '10K',
      'image': 'assets/images/pancalrun.jpeg',
    },
    {
      'title': 'Morning Run Challenge',
      'date': '15 Dec 2025',
      'location': 'Pemalang',
      'distance': '5K',
      'image': 'assets/images/railfuns.jpeg',
    },
    {
      'title': 'Virtual Run – Beat Your Record',
      'date': '1 Jan 2026',
      'location': 'Online',
      'distance': '10K',
      'image': 'assets/images/pancalrun.jpeg',
    },
    {
      'title': 'Fun Run Brebes',
      'date': '17 Nov 2025',
      'location': 'Brebes',
      'distance': '5K',
      'image': 'assets/images/railfuns.jpeg',
    },
    {
      'title': 'Night Run Tegal',
      'date': '25 Nov 2025',
      'location': 'Tegal',
      'distance': '10K',
      'image': 'assets/images/pancalrun.jpeg',
    },
  ];

  // fungsi untuk menerapkan filter — simpel dulu
  List<Map<String, String>> getFilteredEvents() {
    return events.where((event) {
      bool cityMatch = selectedCity == 'Semua' || event['location'] == selectedCity;
      bool distanceMatch = selectedDistance == 'Semua' || event['distance'] == selectedDistance;
      bool timeMatch = selectedTime == 'Semua' || _matchesTime(event['date']!, selectedTime);
      return cityMatch && distanceMatch && timeMatch;
    }).toList();
  }

  // fungsi cek waktu event sesuai filter
  bool _matchesTime(String date, String timeFilter) {
    // parsing manual (simple aja biar ga ribet)
    DateTime eventDate = DateTime.parse(
      date.replaceAll(' ', '-')
      .replaceAll('Nov', '11')
      .replaceAll('Dec', '12')
      .replaceAll('Jan', '01') + '-2026'
    );

    DateTime now = DateTime.now();

    if (timeFilter == 'Minggu Ini') {
      // cek yg seminggu ke depan
      DateTime weekFromNow = now.add(const Duration(days: 7));
      return eventDate.isBefore(weekFromNow) && eventDate.isAfter(now);
    } 
    else if (timeFilter == 'Bulan Depan') {
      // cek bulan depan
      DateTime monthFromNow = DateTime(now.year, now.month + 1, now.day);
      return eventDate.isBefore(monthFromNow) && eventDate.isAfter(now);
    }

    return true; // default lolos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar header event lari
      appBar: AppBar(
        title: Text(
          'Event Lari Terbaru',
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

      body: Column(
        children: [
          // bagian filter
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                Row(
                  children: [
                    // filter kota
                    Expanded(
                      child: _buildFilterDropdown('Kota',
                        ['Semua', 'Tegal', 'Pemalang', 'Brebes'],
                        selectedCity, 
                        (value) {
                          setState(() => selectedCity = value!);
                        }
                      ),
                    ),
                    const SizedBox(width: 12),

                    // filter jarak lari
                    Expanded(
                      child: _buildFilterDropdown('Jarak',
                        ['Semua', '5K', '10K'],
                        selectedDistance, 
                        (value) {
                          setState(() => selectedDistance = value!);
                        }
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // filter waktu
                _buildFilterDropdown('Waktu',
                  ['Semua', 'Minggu Ini', 'Bulan Depan'],
                  selectedTime,
                  (value) {
                    setState(() => selectedTime = value!);
                  }
                ),
              ],
            ),
          ),

          // list event
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: getFilteredEvents().length,
              itemBuilder: (context, index) {
                final event = getFilteredEvents()[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      // shadow tipis biar keliatan modern
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // gambar event
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          event['image']!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,

                          // error fallback kalau gambar ga ketemu
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 150,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // bagian text & tombol
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // title event
                            Text(
                              event['title']!,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // tanggal + lokasi
                            Text(
                              '${event['date']} • ${event['location']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // tombol detail event
                            ElevatedButton(
                              onPressed: () {
                                // sementara cuma snackbar dulu
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Detail untuk ${event['title']}'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              child: Text(
                                'Lihat Detail',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // widget dropdown filter — biar ga ngulang2
  Widget _buildFilterDropdown(String label, List<String> options, String selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // label text filter
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 4),

        // dropdown kotak
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),

          child: DropdownButton<String>(
            value: selectedValue,
            isExpanded: true,
            underline: const SizedBox(),

            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(
                  option,
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
              );
            }).toList(),

            onChanged: onChanged, // update filter
          ),
        ),
      ],
    );
  }
}
