import 'package:animate_do/animate_do.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import '../services/gemini_service.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

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
    if (mounted) {
      setState(() {
        aiTarifler = yanit;
        yukleniyor = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: OrganicBackground(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                          'Tarif ve Analiz',
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FadeInUp(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(milliseconds: 800),
                        child: GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orangeAccent.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.co2_rounded, size: 40, color: Colors.orangeAccent),
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                "Tahmini Karbon Ayak İzi",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "${karbon.toStringAsFixed(2)} kg CO₂e",
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 400),
                        duration: const Duration(milliseconds: 800),
                        child: GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.restaurant_menu_rounded, color: AppTheme.primaryGreen),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Yerel Tarif Eşleşmeleri",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              eslesenTarifler.isEmpty
                                  ? const Text(
                                      "Girdiğiniz malzemelere uygun yerel tarif bulunamadı.",
                                      style: TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic),
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: eslesenTarifler.map((tarif) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.check_circle_outline_rounded, color: AppTheme.secondaryGreen, size: 20),
                                            const SizedBox(width: 10),
                                            Text(tarif, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                                          ],
                                        ),
                                      )).toList(),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      FadeInUp(
                        delay: const Duration(milliseconds: 600),
                        duration: const Duration(milliseconds: 800),
                        child: GlassCard(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.auto_awesome_rounded, color: Colors.purpleAccent),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Yapay Zeka (Gemini) Önerileri",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              yukleniyor
                                  ? const Center(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20.0),
                                        child: CircularProgressIndicator(color: Colors.purpleAccent),
                                      ),
                                    )
                                  : Text(
                                      aiTarifler ?? "Yapay zeka şu an cevap veremiyor.",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: AppTheme.textPrimary,
                                        height: 1.6, // Satır arası boşluğu artırdık
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}