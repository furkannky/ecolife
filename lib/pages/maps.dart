import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart'; // permission_handler paketini import edin

class HaritaEkrani extends StatefulWidget {
  const HaritaEkrani({super.key});

  @override
  State<HaritaEkrani> createState() => _HaritaEkraniState();
}

class _HaritaEkraniState extends State<HaritaEkrani> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), // Başlangıç konumu (örnek)
    zoom: 14.4746,
  );

  GoogleMapController? _controller;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Widget oluşturulduğunda izin iste
  }

  Future<void> _requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    setState(() {
      _locationPermissionGranted = status.isGranted;
    });

    if (status.isGranted) {
      print('Konum izni verildi.');
      // İzin verildikten sonra harita üzerinde "Benim Konumum" özelliği çalışacaktır.
    } else if (status.isDenied) {
      print('Konum izni reddedildi.');
      // Kullanıcıya neden izne ihtiyaç duyduğunuzu açıklayan bir mesaj gösterebilirsiniz.
    } else if (status.isPermanentlyDenied) {
      print('Konum izni kalıcı olarak reddedildi. Kullanıcıyı ayarlara yönlendirin.');
      openAppSettings(); // Kullanıcıyı uygulama ayarlarına yönlendirir.
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harita'),
      ),
      body: _locationPermissionGranted
          ? GoogleMap(
              trafficEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true, // Kullanıcının konumunu göster (izin gerektirir)
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Konum izni gereklidir.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _requestLocationPermission,
                    child: const Text('İzin İste'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: openAppSettings,
                    child: const Text('Ayarlara Git'),
                  ),
                ],
              ),
            ),
    );
  }
}