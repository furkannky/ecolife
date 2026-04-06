import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late String kullaniciAdi;
  late String email;
  double karbonHedefi = 20.0;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    email = user?.email ?? "Bilinmeyen Email";
    
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      kullaniciAdi = user.displayName!;
    } else if (user?.email != null) {
      final namePart = user!.email!.split('@').first;
      kullaniciAdi = namePart[0].toUpperCase() + namePart.substring(1);
    } else {
      kullaniciAdi = "Doğa Dostu";
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrganicBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.primaryGreen),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Profilim",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.primaryGreen,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 800),
                child: GlassCard(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, size: 40, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              kullaniciAdi,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              email,
                              style: TextStyle(fontSize: 15, color: AppTheme.textSecondary),
                            ),
                          ],
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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.track_changes_rounded, color: AppTheme.primaryGreen),
                          const SizedBox(width: 10),
                          Text(
                            "Karbon Hedefi",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Slider(
                        value: karbonHedefi,
                        min: 0.0,
                        max: 50.0,
                        divisions: 5,
                        label: "${karbonHedefi.toStringAsFixed(0)} g CO2",
                        activeColor: AppTheme.primaryGreen,
                        inactiveColor: AppTheme.secondaryGreen.withOpacity(0.3),
                        onChanged: (double value) {
                          setState(() {
                            karbonHedefi = value;
                          });
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Hedef: ${karbonHedefi.toStringAsFixed(0)} g CO2",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                        ),
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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: AppTheme.primaryGreen),
                          const SizedBox(width: 10),
                          Text(
                            "Kazanılan Rozetler",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _rozetSirasi(Icons.star_rounded, Colors.amber, "Başlangıç Rozeti"),
                      const Divider(height: 30, color: Colors.black12),
                      _rozetSirasi(Icons.spa_rounded, AppTheme.primaryGreen, "Yeşil Yıldız Rozeti"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rozetSirasi(IconData icon, Color color, String metin) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 15),
        Text(metin, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
      ],
    );
  }
}