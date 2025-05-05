import 'package:animate_do/animate_do.dart';
import 'package:ecolife/models/user_data.dart';
import 'package:ecolife/pages/community_screen.dart';
import 'package:flutter/material.dart';
import 'maps.dart';
import 'karbon_ayak_izi_bilgi_ekrani.dart';
import 'eco_education_screen.dart';
import '../services/api_service.dart'; // ✅ API servisi importu

class HomeScreen extends StatelessWidget {
  final String kullaniciAdi;
  final String? ulasimTercihi;

  const HomeScreen({super.key, required this.kullaniciAdi, this.ulasimTercihi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: const Text(
          '𝐄𝐂𝐎𝐋İ𝐅𝐄',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pacifico',
          ),
        ),
        centerTitle: true,
      ),
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
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Text(
                  "Hoş geldin, $kullaniciAdi 👋",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 800),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 3,
                  color: Colors.white.withOpacity(0.8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Karbon Ayak İzinizi Merak Ediyor Musunuz?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Günlük seçimlerinizin çevreye olan etkisini öğrenin ve daha sürdürülebilir adımlar atın.',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const KarbonAyakIziBilgiEkrani(),
                                ),
                              );
                            },
                            child: const Text(
                              'Daha Fazla Bilgi',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (ulasimTercihi != null && ulasimTercihi!.isNotEmpty)
                FadeIn(
                  delay: const Duration(milliseconds: 500),
                  child: Text(
                    "Son Ulaşım Tercihi: $ulasimTercihi",
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              const SizedBox(height: 30),
              Expanded(
                child: FadeIn(
                  duration: const Duration(milliseconds: 1200),
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _menuKarti(
                        context,
                        "Topluluk",
                        Icons.group,
                        "/EcoLife Topluluğu",
                        delay: const Duration(milliseconds: 200),
                      ),

                      _menuKarti(
                        context,
                        "🌱 Akıllı Mutfak",
                        Icons.fastfood,
                        "/dolabim",
                        delay: const Duration(milliseconds: 200),
                      ),
                      _menuKarti(
                        context,
                        "📚 Eco Eğitim",
                        Icons.school,
                        "/egitim",
                        delay: const Duration(milliseconds: 1400),
                      ),
                      _menuKarti(
                        context,
                        "🗺️ Yaşam Haritam",
                        Icons.map,
                        "/harita",
                        delay: const Duration(milliseconds: 1200),
                      ),
                      _menuKarti(
                        context,
                        "🚗 Yeşil Ulaşım",
                        Icons.directions_car,
                        "/ulasim",
                        delay: const Duration(milliseconds: 1000),
                      ),
                      _menuKarti(
                        context,
                        "🔍 Ürün Tarayıcı",
                        Icons.qr_code_scanner,
                        "/urun-bilgisi",
                        delay: const Duration(milliseconds: 1800),
                      ),
                      _menuKarti(
                        context,
                        "👤 Profilim",
                        Icons.person,
                        "/profil",
                        delay: const Duration(milliseconds: 800),
                      ),
                      _menuKarti(
                        context,
                        "📊 Skorlarım",
                        Icons.bar_chart,
                        "/skor",
                        delay: const Duration(milliseconds: 600),
                      ),
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

  Widget _menuKarti(
    BuildContext context,
    String baslik,
    IconData ikon,
    String rota, {
    Duration delay = const Duration(milliseconds: 0),
  }) {
    return FadeInUp(
      delay: delay,
      duration: const Duration(milliseconds: 800),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, rota);
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(ikon, size: 50, color: Colors.green.shade700),
                const SizedBox(height: 15),
                Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
