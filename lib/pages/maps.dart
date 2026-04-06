import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/gemini_service.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';
import 'package:animate_do/animate_do.dart';

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
  bool _isLoading = false; 
  String _loadingMessage = ''; 

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
    const istanbulLatLng = LatLng(41.0082, 28.9784); 
    setState(() {
      _currentLocation = istanbulLatLng;
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(istanbulLatLng, 14),
    );
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
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    }).toSet();

    setState(() {
      _markers = newMarkers;
      _isLoading = false;
      _loadingMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: _permissionGranted
          ? OrganicBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primaryGreen),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FadeInDown(
                            duration: const Duration(milliseconds: 800),
                            child: Text(
                              'Yaşam Haritam',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: AppTheme.primaryGreen,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInDown(
                    delay: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: TextField(
                          onSubmitted: _getNearbyPlaces,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Örn: Yakınımdaki geri dönüşüm kutuları',
                            hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.6)),
                            icon: const Icon(Icons.search_rounded, color: AppTheme.primaryGreen),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Stack(
                      children: [
                        FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: Container(
                            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: GoogleMap(
                                initialCameraPosition: _initialCamera,
                                onMapCreated: (controller) => _mapController = controller,
                                myLocationEnabled: true,
                                markers: _markers,
                                mapType: MapType.normal,
                                zoomControlsEnabled: false,
                              ),
                            ),
                          ),
                        ),
                        if (_isLoading)
                          Center(
                            child: FadeIn(
                              child: GlassCard(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CircularProgressIndicator(color: AppTheme.primaryGreen),
                                    const SizedBox(height: 20),
                                    Text(
                                      _loadingMessage,
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: ElevatedButton.icon(
                onPressed: _checkLocationPermission,
                icon: const Icon(Icons.my_location_rounded),
                label: const Text('Konum İzni Ver'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                ),
              ),
            ),
    );
  }
}