import 'package:animate_do/animate_do.dart';
import 'package:ecolife/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class UrunBilgisiAlmaEkran extends StatefulWidget {
  @override
  _UrunBilgisiAlmaEkranState createState() => _UrunBilgisiAlmaEkranState();
}

class _UrunBilgisiAlmaEkranState extends State<UrunBilgisiAlmaEkran> {
  MobileScannerController cameraController = MobileScannerController();
  String? qrSonucu;
  bool _isScanning = false;
  final _formKey = GlobalKey<FormState>();
  final _manuelUrunAdiController = TextEditingController();
  String? _urunBilgisi;
  bool _isLoading = false;
  bool _qrOkumaAktif = false;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> _urunBilgisiniAl(String urunAdi) async {
    setState(() {
      _isLoading = true;
      _urunBilgisi = null;
    });
    try {
      final bilgi = await GeminiService.urunBilgisiAl(urunAdi);
      setState(() {
        _urunBilgisi = bilgi;
        _isLoading = false;
      });
    } catch (e) {
      print('Ürün bilgisi alınırken hata oluştu: $e');
      setState(() {
        _urunBilgisi = 'Ürün bilgisi alınırken bir hata oluştu.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    _manuelUrunAdiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.green.shade900,
              Colors.green.shade800,
              Colors.green.shade400,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: const Text("Ürün Bilgisi Al",
                        style: TextStyle(color: Colors.white, fontSize: 40)),
                  ),
                  const SizedBox(height: 10),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1300),
                    child: const Text(
                        "Ürün hakkında bilgi almak için QR kodunu okuyun veya manuel olarak girin.",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Yöntem Seçim Butonları
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isScanning = true;
                                    _qrOkumaAktif = true;
                                    _urunBilgisi = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _qrOkumaAktif
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                  foregroundColor: _qrOkumaAktif
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null,
                                ),
                                child: const Text('QR Kodunu Oku'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isScanning = false;
                                    _qrOkumaAktif = false;
                                    _urunBilgisi = null;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: !_qrOkumaAktif
                                      ? Theme.of(context).colorScheme.primary
                                      : null,
                                  foregroundColor: !_qrOkumaAktif
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : null,
                                ),
                                child: const Text('Manuel Giriş'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                    
                        // QR Kod Okuma Alanı
                        if (_qrOkumaAktif)
                          SizedBox(
                            height: 300, // Yüksekliği ayarlanabilir
                            child: MobileScanner(
                              controller: cameraController,
                              onDetect: (capture) {
                                try {
                                  final List<Barcode> barcodes = capture.barcodes;
                                  if (barcodes.isNotEmpty &&
                                      barcodes.first.rawValue != null) {
                                    final String? scannedValue =
                                        barcodes.first.rawValue;
                                    print('QR Kod Okundu: $scannedValue');
                                    setState(() {
                                      qrSonucu = scannedValue;
                                      _urunBilgisiniAl(scannedValue!);
                                      _isScanning = false;
                                      _qrOkumaAktif = false;
                                    });
                                  } else if (barcodes.isEmpty) {
                                    print('Hiç barkod algılanmadı.');
                                  } else if (barcodes.first.rawValue == null) {
                                    print('Okunan barkodun değeri boş.');
                                  }
                                } catch (e) {
                                  print('QR kod okuma sırasında hata oluştu: $e');
                                }
                              },
                            ),
                          ),
                    
                        // Manuel Giriş Alanı
                        if (!_qrOkumaAktif)
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: _manuelUrunAdiController,
                                  decoration: const InputDecoration(
                                    labelText: 'Ürün Adı',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Lütfen ürün adını girin';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          if (_formKey.currentState!.validate()) {
                                            _urunBilgisiniAl(
                                                _manuelUrunAdiController.text);
                                          }
                                        },
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Bilgi Al'),
                                ),
                              ],
                            ),
                          ),
                    
                        const SizedBox(height: 20),
                    
                        // Ürün Bilgisi Gösterim Alanı
                        if (_urunBilgisi != null)
                          SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ürün Bilgisi:',
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _urunBilgisi!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}