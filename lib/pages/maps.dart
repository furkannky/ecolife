import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../services/gemini_service.dart'; // kendi klasör yapına göre yolu düzenle

class HaritaEkrani extends StatefulWidget {
  const HaritaEkrani({super.key});

  @override
  State<HaritaEkrani> createState() => _HaritaEkraniState();
}

class _HaritaEkraniState extends State<HaritaEkrani> {
  final CameraPosition _initialCamera = const CameraPosition(
    target: LatLng(41.0082, 28.9784), // İstanbul
    zoom: 12,
  );

  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Set<Marker> _markers = {};
  bool _permissionGranted = false;
  bool _isLoading = false; // Yükleniyor durumunu kontrol etmek için
  String _loadingMessage = ''; // Yükleniyor mesajını saklamak için

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() => _permissionGranted = true);
      _getCurrentLocation();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _getCurrentLocation() async {
    // Gerçek konum alma yerine sabit İstanbul konumu
    const istanbulLatLng = LatLng(41.0082, 28.9784); // İstanbul koordinatları

    setState(() {
      _currentLocation = istanbulLatLng;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(istanbulLatLng, 14),
    );

    print("Manuel konum: İstanbul gösteriliyor.");
  }

  Future<void> _getNearbyPlaces(String userQuery) async {
    if (_currentLocation == null) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = 'Yapay zeka yakındaki mekanları arıyor...';
      _markers.clear();
    });

    final keyword = await GeminiService.extractKeywords(userQuery);

    const apiKey = 'AIzaSyA4BaZTZssPTKp4gWuSSCQ_L1XCDvZO9mo';
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_currentLocation!.latitude},${_currentLocation!.longitude}'
        '&radius=5000'
        '&keyword=$keyword'
        '&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode != 200) {
      setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arama sırasında bir hata oluştu.')),
      );
      return;
    }

    final data = jsonDecode(response.body);
    if (data['status'] != 'OK') {
      setState(() {
        _isLoading = false;
        _loadingMessage = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Arama sonuçları alınamadı.')),
      );
      return;
    }

    final places = data['results'] as List;
    final newMarkers = places.map((place) {
      final lat = place['geometry']['location']['lat'];
      final lng = place['geometry']['location']['lng'];
      final name = place['name'];
      final id = place['place_id'];

      return Marker(
        markerId: MarkerId(id),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: name),
      );
    }).toSet();

    setState(() {
      _markers = newMarkers;
      _isLoading = false;
      _loadingMessage = '';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sonuçlar bulundu!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harita'),
        backgroundColor: Colors.green.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _permissionGranted
          ? Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        onSubmitted: _getNearbyPlaces,
                        decoration: const InputDecoration(
                          labelText: 'Ne arıyorsunuz?',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GoogleMap(
                        initialCameraPosition: _initialCamera,
                        onMapCreated: (controller) => _mapController = controller,
                        myLocationEnabled: true,
                        markers: _markers,
                        mapType: MapType.normal,
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 24.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            _loadingMessage,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            )
          : Center(
              child: ElevatedButton(
                onPressed: _checkLocationPermission,
                child: const Text('Konum izni ver'),
              ),
            ),
    );
  }
}