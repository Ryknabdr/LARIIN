import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';

class ScanMakananTab extends StatefulWidget {
  const ScanMakananTab({super.key});

  @override
  State<ScanMakananTab> createState() => _ScanMakananTabState();
}

class _ScanMakananTabState extends State<ScanMakananTab> {
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
        title: const Text('Scan Makanan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Metode Scan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // Scan Options
            Row(
              children: [
                Expanded(
                  child: _buildScanOption(
                    context,
                    Icons.camera_alt,
                    'Kamera',
                    'Ambil foto makanan',
                    () => _pickImage(ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildScanOption(
                    context,
                    Icons.photo_library,
                    'Galeri',
                    'Pilih dari galeri',
                    () => _pickImage(ImageSource.gallery),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Image Preview
            if (_image != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: FileImage(_image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Scan Result
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Hasil Scan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_result.isNotEmpty)
                      Center(
                        child: Text(
                          _result,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                    else
                      const Center(
                        child: Text(
                          'Pilih gambar untuk mulai scan',
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

  Widget _buildScanOption(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap, {bool fullWidth = false}) {
    final child = InkWell(
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

    if (fullWidth) {
      return child;
    } else {
      return Expanded(child: child);
    }
  }
}
