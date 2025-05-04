import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/gemini_service.dart'; // bunu eklemeyi unutma

class TarifEkrani extends StatefulWidget {
  final List<String> malzemeler;

  const TarifEkrani({super.key, required this.malzemeler});
  static Route route(RouteSettings settings) {
    final malzemeler = settings.arguments as List<String>;
    return MaterialPageRoute(
      builder: (_) => TarifEkrani(malzemeler: malzemeler),
    );
  }

  @override
  State<TarifEkrani> createState() => _TarifEkraniState();
}

class _TarifEkraniState extends State<TarifEkrani> {
  late List<String> eslesenTarifler;
  double karbon = 0.0;
  String? aiTarifler;
  bool yukleniyor = true;

  final List<Map<String, dynamic>> tarifler = [
    {
      "isim": "Menemen",
      "malzemeler": ["domates", "biber", "yumurta"],
    },
    {
      "isim": "Omlet",
      "malzemeler": ["yumurta", "peynir"],
    },
    {
      "isim": "Salata",
      "malzemeler": ["domates", "salatalık", "zeytinyağı"],
    },
    {
      "isim": "Sebzeli Makarna",
      "malzemeler": ["makarna", "biber", "domates"],
    },
  ];

  final Map<String, double> karbonDegerleri = {
    "et": 27.0,
    "tavuk": 6.9,
    "balık": 6.1,
    "yumurta": 4.8,
    "peynir": 13.5,
    "domates": 1.1,
    "salatalık": 0.7,
    "biber": 1.2,
    "makarna": 1.8,
    "zeytinyağı": 6.0,
  };

  List<String> eslesenTarifleriBul(List<String> kullaniciMalzemeleri) {
    List<String> eslesenTarifler = [];
    final kullaniciSeti =
        kullaniciMalzemeleri.map((e) => e.toLowerCase()).toSet();

    for (var tarif in tarifler) {
      final tarifMalzemeler =
          List<String>.from(tarif["malzemeler"]).map((e) => e.toLowerCase());
      final eslesti =
          tarifMalzemeler.every((malzeme) => kullaniciSeti.contains(malzeme));
      if (eslesti) {
        eslesenTarifler.add(tarif["isim"]);
      }
    }

    return eslesenTarifler;
  }

  double karbonHesapla(List<String> malzemeler) {
    double toplamKarbon = 0.0;

    for (var malzeme in malzemeler) {
      final m = malzeme.toLowerCase();
      if (karbonDegerleri.containsKey(m)) {
        toplamKarbon += karbonDegerleri[m]!;
      }
    }

    return toplamKarbon;
  }

  @override
  void initState() {
    super.initState();
    eslesenTarifler = eslesenTarifleriBul(widget.malzemeler);
    karbon = karbonHesapla(widget.malzemeler);
    _aiTarifleriGetir();
  }

  Future<void> _aiTarifleriGetir() async {
    final yanit = await GeminiService.tarifOner(widget.malzemeler);
    setState(() {
      aiTarifler = yanit;
      yukleniyor = false;
    });
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FadeIn(
            duration: const Duration(milliseconds: 1000),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: const Text(
                      "Tarif ve Karbon Analizi",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 30),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 800),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Karbon Ayak İzi Tahmini:",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "${karbon.toStringAsFixed(2)} kg CO₂e",
                              style: const TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 400),
                    duration: const Duration(milliseconds: 800),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Eşleşen Yerel Tarifler:",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700),
                            ),
                            const SizedBox(height: 8),
                            eslesenTarifler.isEmpty
                                ? const Text("Uygun tarif bulunamadı.")
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: eslesenTarifler
                                        .map((tarif) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              child: Text("- $tarif",
                                                  style: const TextStyle(
                                                      fontSize: 16)),
                                            ))
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FadeInUp(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 800),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              "Yapay Zeka Tarif Önerileri:",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700),
                            ),
                            const SizedBox(height: 8),
                            yukleniyor
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Text(aiTarifler ?? "Tarif bulunamadı.",
                                    style: const TextStyle(fontSize: 16)),
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
    );
  }
}