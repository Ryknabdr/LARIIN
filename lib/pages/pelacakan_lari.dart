import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'dart:math' as math;

class PelacakanLariTab extends StatefulWidget {
  const PelacakanLariTab({super.key});

  @override
  State<PelacakanLariTab> createState() => _PelacakanLariTabState();
}

class _PelacakanLariTabState extends State<PelacakanLariTab> {
  final Location _location = Location();
  bool _isTracking = false;
  final List<LatLng> _route = [];
  double _distance = 0.0;
  Duration _duration = Duration.zero;
  Timer? _timer;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    LocationData locationData = await _location.getLocation();
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  void _startTracking() {
    setState(() {
      _isTracking = true;
      _route.clear();
      _distance = 0.0;
      _duration = Duration.zero;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _duration += const Duration(seconds: 1);
        });
      }
    });

    _location.onLocationChanged.listen((LocationData currentLocation) {
      LatLng newPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
      if (mounted) {
        setState(() {
          if (_route.isNotEmpty) {
            _distance += _calculateDistance(_route.last, newPosition);
          }
          _route.add(newPosition);
          _currentPosition = newPosition;
        });
      }
    });
  }

  void _stopTracking() {
    setState(() {
      _isTracking = false;
    });
    _timer?.cancel();
  }

  double _calculateDistance(LatLng start, LatLng end) {
    // Simple distance calculation (Haversine formula approximation)
    const double earthRadius = 6371; // km
    double dLat = (end.latitude - start.latitude) * (math.pi / 180);
    double dLng = (end.longitude - start.longitude) * (math.pi / 180);
    double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLng / 2) * math.sin(dLng / 2) * math.cos(start.latitude * math.pi / 180) * math.cos(end.latitude * math.pi / 180);
    double c = 2 * math.atan2(math.sqrt(1 - a), math.sqrt(a));
    return earthRadius * c * 1000; // meters
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelacakan Lari'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: _currentPosition == null
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15,
                    ),
                    onMapCreated: (controller) {},
                    myLocationEnabled: true,
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: _route,
                        color: Colors.blue,
                        width: 5,
                      ),
                    },
                  ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Jarak: ${(_distance / 1000).toStringAsFixed(2)} km',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Durasi: ${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isTracking ? _stopTracking : _startTracking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isTracking ? Colors.red : Colors.green,
                      minimumSize: const Size(150, 50),
                    ),
                    child: Text(_isTracking ? 'Stop' : 'Start'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
