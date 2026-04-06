import 'package:animate_do/animate_do.dart';
import 'package:ecolife/services/gemini_service.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

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
      if (mounted) {
        setState(() {
          _urunBilgisi = bilgi;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Ürün bilgisi alınırken hata oluştu: $e');
      if (mounted) {
        setState(() {
          _urunBilgisi = 'Ürün bilgisi alınırken bir hata oluştu.';
          _isLoading = false;
        });
      }
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
      backgroundColor: AppTheme.background,
      body: OrganicBackground(
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
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        'Ürün Tarayıcı',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeInDown(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 1300),
                child: Text(
                  'Ürünün QR kodunu okutup karbon ayak izini öğrenin.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: GlassCard(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isScanning = true;
                                      _qrOkumaAktif = true;
                                      _urunBilgisi = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: _qrOkumaAktif ? AppTheme.primaryGreen : Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'QR Oku',
                                        style: TextStyle(
                                          color: _qrOkumaAktif ? Colors.white : AppTheme.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _isScanning = false;
                                      _qrOkumaAktif = false;
                                      _urunBilgisi = null;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    decoration: BoxDecoration(
                                      color: !_qrOkumaAktif ? AppTheme.primaryGreen : Colors.transparent,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Manuel Seç',
                                        style: TextStyle(
                                          color: !_qrOkumaAktif ? Colors.white : AppTheme.textPrimary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      if (_qrOkumaAktif)
                        FadeIn(
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              height: 300,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: MobileScanner(
                                  controller: cameraController,
                                  onDetect: (capture) {
                                    try {
                                      final List<Barcode> barcodes = capture.barcodes;
                                      if (barcodes.isNotEmpty &&
                                          barcodes.first.rawValue != null) {
                                        final String? scannedValue =
                                            barcodes.first.rawValue;
                                        if (mounted) {
                                          setState(() {
                                            qrSonucu = scannedValue;
                                            _urunBilgisiniAl(scannedValue!);
                                            _isScanning = false;
                                            _qrOkumaAktif = false;
                                          });
                                        }
                                      }
                                    } catch (e) {
                                      print('Hata: $e');
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      if (!_qrOkumaAktif && _urunBilgisi == null)
                        FadeIn(
                           child: GlassCard(
                             padding: const EdgeInsets.all(24),
                             child: Form(
                               key: _formKey,
                               child: Column(
                                 children: <Widget>[
                                   TextFormField(
                                     controller: _manuelUrunAdiController,
                                     decoration: InputDecoration(
                                       labelText: 'Ürün Adını Giriniz',
                                       labelStyle: TextStyle(color: AppTheme.textSecondary),
                                       border: OutlineInputBorder(
                                         borderRadius: BorderRadius.circular(15),
                                       ),
                                     ),
                                     validator: (value) {
                                       if (value == null || value.isEmpty) {
                                         return 'Lütfen ürün adı giriniz';
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
                                     style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(double.infinity, 55),
                                     ),
                                     child: _isLoading
                                         ? const CircularProgressIndicator(color: Colors.white)
                                         : const Text('Bilgi Al', style: TextStyle(fontSize: 18)),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                        ),
                      
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 40.0),
                          child: Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
                        ),

                      if (_urunBilgisi != null)
                        FadeInUp(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: GlassCard(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.info_outline_rounded, color: AppTheme.primaryGreen),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Analiz Sonucu',
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    _urunBilgisi!,
                                    style: TextStyle(fontSize: 16, height: 1.5, color: AppTheme.textSecondary),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        _urunBilgisi = null;
                                      });
                                    },
                                    icon: const Icon(Icons.refresh_rounded),
                                    label: const Text('Yeni Arama Yap'),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 50),
                                      backgroundColor: AppTheme.secondaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 40),
                    ],
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