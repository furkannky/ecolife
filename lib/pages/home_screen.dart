import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecolife/models/user_data.dart';
import 'package:ecolife/pages/community_screen.dart';
import 'package:flutter/material.dart';
import 'maps.dart';
import 'karbon_ayak_izi_bilgi_ekrani.dart';
import 'eco_education_screen.dart';
import '../services/api_service.dart';
import '../constants/app_theme.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  final String kullaniciAdi;
  final String? ulasimTercihi;

  const HomeScreen({super.key, required this.kullaniciAdi, this.ulasimTercihi});

  @override
  Widget build(BuildContext context) {
    // Scaffold is provided by OrganicBackground, we just provide the inner body
    return OrganicBackground(
      child: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 1000),
                    child: _buildCarbonCard(context),
                  ),
                  if (ulasimTercihi != null && ulasimTercihi!.isNotEmpty) ...[
                    const SizedBox(height: 15),
                    FadeInLeft(
                      child: _buildTransportCard(context),
                    ),
                  ],
                  const SizedBox(height: 25),
                  FadeInUp(
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      "Servisler",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.95, // Slightly taller cards
              ),
              delegate: SliverChildListDelegate([
                _menuKarti(context, "Topluluk", Icons.group_rounded, "/EcoLife Topluluğu", AppTheme.secondaryGreen, delay: 100),
                _menuKarti(context, "Akıllı Mutfak", Icons.fastfood_rounded, "/dolabim", Colors.orange.shade400, delay: 200),
                _menuKarti(context, "Eco Eğitim", Icons.menu_book_rounded, "/egitim", Colors.blue.shade400, delay: 300),
                _menuKarti(context, "Yaşam Haritam", Icons.map_rounded, "/harita", Colors.teal.shade400, delay: 400),
                _menuKarti(context, "Yeşil Ulaşım", Icons.directions_car_filled_rounded, "/ulasim", Colors.indigo.shade400, delay: 500),
                _menuKarti(context, "Ürün Tarayıcı", Icons.qr_code_scanner_rounded, "/urun-bilgisi", Colors.purple.shade400, delay: 600),
                _menuKarti(context, "Profilim", Icons.person_rounded, "/profil", Colors.pink.shade400, delay: 700),
                _menuKarti(context, "Skorlarım", Icons.bar_chart_rounded, "/skor", Colors.red.shade400, delay: 800),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String displayAdi = kullaniciAdi;
    if (displayAdi.isEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.displayName != null && user!.displayName!.isNotEmpty) {
        displayAdi = user.displayName!;
      } else if (user?.email != null) {
        final namePart = user!.email!.split('@').first;
        displayAdi = namePart[0].toUpperCase() + namePart.substring(1);
      } else {
        displayAdi = "Doğa Dostu";
      }
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInDown(
                  child: Text(
                    "ECOLIFE",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    "Hoş geldin, $displayAdi 👋",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            FadeInRight(
              child: GlassCard(
                padding: const EdgeInsets.all(10),
                borderRadius: BorderRadius.circular(15),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppTheme.primaryGreen,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarbonCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: Colors.white.withOpacity(0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.eco_rounded, color: AppTheme.primaryGreen),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  'Karbon Ayak İzinizi Merak Ediyor Musunuz?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Günlük seçimlerinizin çevreye olan etkisini öğrenin ve daha sürdürülebilir adımlar atın.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KarbonAyakIziBilgiEkrani(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('İncele'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      backgroundColor: Colors.white.withOpacity(0.3),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
      child: Row(
        children: [
          const Icon(Icons.directions_bike_rounded, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Text(
            "Son Ulaşım Tercihi: $ulasimTercihi",
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuKarti(BuildContext context, String baslik, IconData ikon, String rota, Color iconColor, {int delay = 0}) {
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      duration: const Duration(milliseconds: 800),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, rota);
        },
        child: GlassCard(
          padding: EdgeInsets.zero, // Padding handled internally for layout
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(ikon, size: 38, color: iconColor.withOpacity(0.9)),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
