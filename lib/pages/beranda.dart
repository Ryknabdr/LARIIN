import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class BerandaTab extends StatefulWidget {
  const BerandaTab({super.key});

  @override
  State<BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<BerandaTab> {
  File? _image;
  String _result = '';
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _result = '';
      });
      _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    final inputImage = InputImage.fromFile(_image!);
    final imageLabeler = GoogleMlKit.vision.imageLabeler();

    try {
      final labels = await imageLabeler.processImage(inputImage);
      String foodLabels = labels
          .where((label) => label.confidence > 0.5) // Filter confidence > 50%
          .map((label) => '${label.label} (${(label.confidence * 100).toStringAsFixed(1)}%)')
          .join(', ');

      setState(() {
        _result = foodLabels.isNotEmpty ? 'Makanan terdeteksi: $foodLabels' : 'Tidak ada makanan terdeteksi';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }

    imageLabeler.close();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lariin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.blue.shade700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Selamat Datang!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pantau nutrisi dan aktivitas Anda dengan AI',
                      style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Quick Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Kalori Hari Ini',
                      '1,250',
                      'kcal',
                      Icons.local_fire_department,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Langkah',
                      '8,450',
                      'steps',
                      Icons.directions_walk,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Challenge Slider
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.emoji_events, color: Colors.purple),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Tantangan Minggu Ini',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildChallengeCard(
                            'Lari 10km',
                            'Progress: 7.5km',
                            0.75,
                            Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          _buildChallengeCard(
                            'Kalori 2000',
                            'Progress: 1250kcal',
                            0.625,
                            Colors.orange,
                          ),
                          const SizedBox(width: 12),
                          _buildChallengeCard(
                            'Langkah 10000',
                            'Progress: 8450 steps',
                            0.845,
                            Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // // AI Scan Makanan Section with Navbar
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withOpacity(0.1),
              //         spreadRadius: 1,
              //         blurRadius: 5,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Row(
              //         children: [
              //           Container(
              //             padding: const EdgeInsets.all(8),
              //             decoration: BoxDecoration(
              //               color: Colors.blue.withOpacity(0.1),
              //               borderRadius: BorderRadius.circular(8),
              //             ),
              //             child: const Icon(Icons.restaurant, color: Colors.blue),
              //           ),
              //           const SizedBox(width: 12),
              //           const Expanded(
              //             child: Text(
              //               'AI Scan Makanan',
              //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              //             ),
              //           ),
              //         ],
              //       ),
              //       const SizedBox(height: 10),
              //       const Text(
              //         'Scan makanan untuk analisis nutrisi instan',
              //         style: TextStyle(color: Colors.grey, fontSize: 14),
              //       ),
              //       const SizedBox(height: 15),

              //       // Scan Container inside card
              //       Container(
              //         height: 150,
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.blue.withOpacity(0.3), width: 2),
              //           borderRadius: BorderRadius.circular(12),
              //           color: Colors.blue[50],
              //         ),
              //         child: _image != null
              //             ? ClipRRect(
              //                 borderRadius: BorderRadius.circular(10),
              //                 child: Image.file(_image!, fit: BoxFit.cover),
              //               )
              //             : Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 children: [
              //                   Icon(Icons.camera_alt, size: 50, color: Colors.blue.withOpacity(0.7)),
              //                   const SizedBox(height: 8),
              //                   const Text(
              //                     'Tap untuk scan',
              //                     style: TextStyle(color: Colors.blue, fontSize: 14),
              //                   ),
              //                 ],
              //               ),
              //       ),
              //       const SizedBox(height: 15),

              //       // Action Buttons inside card
              //       Row(
              //         children: [
              //           Expanded(
              //             child: ElevatedButton.icon(
              //               onPressed: () => _pickImage(ImageSource.camera),
              //               icon: const Icon(Icons.camera, size: 18),
              //               label: const Text('Kamera', style: TextStyle(fontSize: 14)),
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.blue,
              //                 foregroundColor: Colors.white,
              //                 padding: const EdgeInsets.symmetric(vertical: 10),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //             ),
              //           ),
              //           const SizedBox(width: 8),
              //           Expanded(
              //             child: ElevatedButton.icon(
              //               onPressed: () => _pickImage(ImageSource.gallery),
              //               icon: const Icon(Icons.photo, size: 18),
              //               label: const Text('Galeri', style: TextStyle(fontSize: 14)),
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.white,
              //                 foregroundColor: Colors.blue,
              //                 side: const BorderSide(color: Colors.blue),
              //                 padding: const EdgeInsets.symmetric(vertical: 10),
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 20),

              // // Analysis Result (moved outside the card)
              // if (_isLoading)
              //   Container(
              //     padding: const EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //       color: Colors.blue[50],
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     child: const Row(
              //       children: [
              //         CircularProgressIndicator(),
              //         SizedBox(width: 15),
              //         Expanded(
              //           child: Text(
              //             'Menganalisis gambar dengan AI...',
              //             style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              //           ),
              //         ),
              //       ],
              //     ),
              //   )
              // else if (_result.isNotEmpty)
              //   Container(
              //     padding: const EdgeInsets.all(20),
              //     decoration: BoxDecoration(
              //       color: Colors.green[50],
              //       borderRadius: BorderRadius.circular(12),
              //       border: Border.all(color: Colors.green, width: 1),
              //     ),
              //     child: Column(
              //       children: [
              //         Row(
              //           children: [
              //             const Icon(Icons.restaurant, color: Colors.green, size: 30),
              //             const SizedBox(width: 10),
              //             const Text(
              //               'Hasil Analisis',
              //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 10),
              //         Text(
              //           _result,
              //           style: const TextStyle(fontSize: 16, color: Colors.black87),
              //         ),
              //       ],
              //     ),
              //   ),

              // Recent Activity
              const Text(
                'Aktivitas Terbaru',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildActivityItem('Lari pagi', '2.5 km • 25 menit', Icons.directions_run, Colors.orange),
              _buildActivityItem('Scan sarapan', 'Oatmeal & Buah', Icons.restaurant, Colors.green),
              _buildActivityItem('Workout', 'Push-up & Squat', Icons.fitness_center, Colors.blue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String unit, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            unit,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(String title, String progress, double progressValue, Color color) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            progress,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progressValue,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
