import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PelacakanLariTab extends StatefulWidget {
  const PelacakanLariTab({super.key});

  @override
  State<PelacakanLariTab> createState() => _PelacakanLariTabState();
}

class _PelacakanLariTabState extends State<PelacakanLariTab> with WidgetsBindingObserver {
  final Completer<GoogleMapController> _mapController = Completer();

  bool _mapReady = false;

  final List<LatLng> _route = [];
  StreamSubscription<Position>? _positionStreamSubscription;
  Position? _lastPosition;
  double _distance = 0.0; // in km
  int _seconds = 0;
  Timer? _timer;
  bool _isTracking = false;
  bool _isPaused = false;
  bool _permissionDenied = false;

  final CameraPosition _initialCameraPosition = const CameraPosition(
    target: LatLng(-6.1751, 106.8650), // Jakarta coords by default for example
    zoom: 15,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Delay permission check until after first frame to ensure map is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionOnStart();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _positionStreamSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isTracking && state == AppLifecycleState.resumed && !_isPaused) {
      // resume tracking if needed
      _subscribePositionStream();
    } else if (state == AppLifecycleState.paused) {
      // pause subscription when app not active
      _positionStreamSubscription?.pause();
    }
  }

  Future<void> _checkPermissionOnStart() async {
    bool granted = await _checkLocationPermission();
    setState(() {
      _permissionDenied = !granted;
    });

    if (granted) {
      try {
        Position pos = await Geolocator.getCurrentPosition();
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(pos.latitude, pos.longitude),
            18,
          ),
        );
      } catch (e) {
        // Handle error silently
      }
    }
  }

  Future<bool> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return false;
      }
    }
    return true;
  }

  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izin Lokasi Ditolak'),
        content: const Text('Aplikasi memerlukan izin lokasi tepat untuk melakukan pelacakan. Mohon aktifkan layanan lokasi dan berikan izin.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          )
        ],
      ),
    );
  }

  void _startTracking() async {
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      _showLocationDeniedDialog();
      setState(() {
        _permissionDenied = true;
      });
      return;
    }
    setState(() {
      _isTracking = true;
      _isPaused = false;
      _distance = 0.0;
      _seconds = 0;
      _route.clear();
      _lastPosition = null;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });

    // Subscribe to position stream and await first location update before animating camera
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 3,
      ),
    ).listen((position) async {
      LatLng currentLatLng = LatLng(position.latitude, position.longitude);

      // Debug location received
      // ignore: avoid_print
      print('Location update: ${position.latitude}, ${position.longitude}');

      if (_lastPosition != null) {
        double addedDistance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        ) / 1000.0; // meter to km
        _distance += addedDistance;
      }
      _lastPosition = position;

      if (_route.isEmpty) {
        // Add initial position immediately to start polyline from first point
        _route.add(currentLatLng);

        // Animate camera immediately when starting
        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(currentLatLng, 17));
      } else {
        _route.add(currentLatLng);

        final GoogleMapController controller = await _mapController.future;
        controller.animateCamera(CameraUpdate.newLatLng(currentLatLng));
      }

      setState(() {});
    });
  }

  void _subscribePositionStream() {
    // Remove this method's usage to avoid duplicate subscription code as it's merged in _startTracking now
    // But keep it if needed for pause/resume behavior
  }

  void _pauseTracking() {
    if (!_isTracking) return;
    setState(() {
      _isPaused = !_isPaused;
    });

    if (_isPaused) {
      _positionStreamSubscription?.pause();
      _timer?.cancel();
    } else {
      _positionStreamSubscription?.resume();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
    }
  }

  void _stopTracking() {
    if (!_isTracking) return;
    _positionStreamSubscription?.cancel();
    _timer?.cancel();
    setState(() {
      _isTracking = false;
      _isPaused = false;
    });

    // TODO: Save data or further processing here, if needed
    _route.clear();
    _distance = 0.0;
    _seconds = 0;
    _lastPosition = null;
  }

  String _formatDuration(int seconds) {
    int m = seconds ~/ 60;
    int s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final Set<Polyline> polylines = {};
    if (_route.length > 1) {
      polylines.add(Polyline(
        polylineId: const PolylineId('route_polyline'),
        points: _route,
        color: Colors.blueAccent,
        width: 5,
      ));
    }

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            key: const ValueKey('google_map'), // Force stable widget identity to avoid blank on reload
            initialCameraPosition: _initialCameraPosition,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            compassEnabled: true,
            tiltGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
            polylines: polylines,
            markers: _lastPosition != null ? {
              Marker(
                markerId: const MarkerId('user_location'),
                position: LatLng(_lastPosition!.latitude, _lastPosition!.longitude),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              )
            } : {},
          onMapCreated: (controller) {
              if (!_mapController.isCompleted) _mapController.complete(controller);

              setState(() {
                _mapReady = true;
              });

              // After map is ready, try moving to current location if permission granted
              _checkPermissionOnStart();
            },
          ),

          if (_isTracking && _lastPosition == null)
            const Positioned.fill(
              child: Center(
                child: Card(
                  color: Colors.white70,
                  elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      'Menunggu data lokasi...',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white.withOpacity(0.9),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Jarak (km)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_distance.toStringAsFixed(2)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Durasi', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_formatDuration(_seconds)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Pace (min/km)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_distance > 0 ? ((_seconds / 60) / _distance).toStringAsFixed(2) : '0.00'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCircleButton(
                  icon: _isTracking && !_isPaused ? Icons.pause : Icons.play_arrow,
                  onPressed: () {
                    if (!_isTracking) {
                      _startTracking();
                    } else {
                      _pauseTracking();
                    }
                  },
                  tooltip: _isTracking && !_isPaused ? 'Pause' : 'Start',
                ),
                _buildCircleButton(
                  icon: Icons.stop,
                  onPressed: _isTracking ? _stopTracking : null,
                  tooltip: 'Stop',
                ),
              ],
            ),
          ),

          if (_permissionDenied)
            Positioned.fill(
              child: Container(
                color: Colors.white70,
                child: Center(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.location_off),
                    label: const Text('Izin Lokasi Ditolak\nAktifkan & Refresh'),
                    onPressed: () async {
                      bool granted = await _checkLocationPermission();
                      setState(() {
                        _permissionDenied = !granted;
                      });
                      if (!granted) {
                        _showLocationDeniedDialog();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          side: const BorderSide(color: Colors.black26),
          backgroundColor: Colors.white.withOpacity(0.5),
          foregroundColor: Colors.black87,
          elevation: 3,
          minimumSize: const Size(60, 60),
        ),
        child: Icon(icon, size: 30),
      ),
    );
  }
}
