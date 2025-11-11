import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String selectedCity = 'Semua';
  String selectedDistance = 'Semua';
  String selectedTime = 'Semua';

  final List<Map<String, String>> events = [
    {
      'title': 'Jakarta Run 10K',
      'date': '24 Nov 2025',
      'location': 'Jakarta',
      'distance': '10K',
      'image': 'assets/images/pancalrun.jpeg',
    },
    {
      'title': 'Morning Run Challenge',
      'date': '15 Dec 2025',
      'location': 'Bandung',
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
      'title': 'Fun Run Surabaya',
      'date': '17 Nov 2025',
      'location': 'Surabaya',
      'distance': '5K',
      'image': 'assets/images/railfuns.jpeg',
    },
    {
      'title': 'Night Run Bandung',
      'date': '25 Nov 2025',
      'location': 'Bandung',
      'distance': '10K',
      'image': 'assets/images/pancalrun.jpeg',
    },
  ];

  List<Map<String, String>> getFilteredEvents() {
    return events.where((event) {
      bool cityMatch = selectedCity == 'Semua' || event['location'] == selectedCity;
      bool distanceMatch = selectedDistance == 'Semua' || event['distance'] == selectedDistance;
      bool timeMatch = selectedTime == 'Semua' || _matchesTime(event['date']!, selectedTime);
      return cityMatch && distanceMatch && timeMatch;
    }).toList();
  }

  bool _matchesTime(String date, String timeFilter) {
    // Simple date parsing for demo; in real app, use proper date handling
    DateTime eventDate = DateTime.parse(date.replaceAll(' ', '-').replaceAll('Nov', '11').replaceAll('Dec', '12').replaceAll('Jan', '01') + '-2025');
    DateTime now = DateTime.now();
    if (timeFilter == 'Minggu Ini') {
      DateTime weekFromNow = now.add(const Duration(days: 7));
      return eventDate.isBefore(weekFromNow) && eventDate.isAfter(now);
    } else if (timeFilter == 'Bulan Depan') {
      DateTime monthFromNow = DateTime(now.year, now.month + 1, now.day);
      return eventDate.isBefore(monthFromNow) && eventDate.isAfter(now);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[50],
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildFilterDropdown('Kota', ['Semua', 'Jakarta', 'Bandung', 'Surabaya'], selectedCity, (value) {
                        setState(() => selectedCity = value!);
                      }),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildFilterDropdown('Jarak', ['Semua', '5K', '10K'], selectedDistance, (value) {
                        setState(() => selectedDistance = value!);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildFilterDropdown('Waktu', ['Semua', 'Minggu Ini', 'Bulan Depan'], selectedTime, (value) {
                  setState(() => selectedTime = value!);
                }),
              ],
            ),
          ),
          // Event List
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
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          event['image']!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
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
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['title']!,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${event['date']} • ${event['location']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to event detail
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Detail untuk ${event['title']}'), duration: Duration(seconds: 2)),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B35),
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

  Widget _buildFilterDropdown(String label, List<String> options, String selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 4),
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
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
