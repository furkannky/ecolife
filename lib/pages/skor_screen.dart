import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/organic_background.dart';
import '../widgets/glass_card.dart';
import '../constants/app_theme.dart';

class SkorScreen extends StatefulWidget {
  const SkorScreen({super.key});

  @override
  State<SkorScreen> createState() => _SkorScreenState();
}

class _SkorScreenState extends State<SkorScreen> {
  double karbonSkoru = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getKarbonSkoru();
  }

  // Firestore'dan karbon skorunu almak
  Future<void> _getKarbonSkoru() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        var userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          karbonSkoru = userData['karbonSkoru'] ?? 0.0;
          isLoading = false; // Veri alındığında loading durumu bitiyor
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryGreen),
        ),
      );
    }

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
                      "Karbon Skorunuz",
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                  backgroundColor: Colors.white.withOpacity(0.4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.eco_rounded, size: 60, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Bugünkü Skor",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        karbonSkoru.toStringAsFixed(2),
                        style: const TextStyle(
                            fontSize: 56, 
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Karbon Puanı",
                        style: TextStyle(fontSize: 18, color: AppTheme.textPrimary, fontWeight: FontWeight.w600),
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
                          const Icon(Icons.show_chart_rounded, color: AppTheme.primaryGreen),
                          const SizedBox(width: 10),
                          Text(
                            "Haftalık Takip",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _karbonTakibi("Pazartesi", 4.5),
                      _karbonTakibi("Salı", 4.0),
                      _karbonTakibi("Çarşamba", 3.8),
                      _karbonTakibi("Perşembe", 4.2),
                      _karbonTakibi("Cuma", 4.0),
                      _karbonTakibi("Cumartesi", 3.5),
                      _karbonTakibi("Pazar", 5.0, isLast: true),
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

  Widget _karbonTakibi(String gun, double puan, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(gun, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
              Row(
                children: [
                  Text(puan.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppTheme.primaryGreen)),
                  const SizedBox(width: 5),
                  const Text("PT", style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                ],
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Colors.black12),
      ],
    );
  }
}
